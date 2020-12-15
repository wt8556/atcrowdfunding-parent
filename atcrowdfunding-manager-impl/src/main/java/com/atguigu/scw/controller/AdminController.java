package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.AdminService;
import com.atguigu.scw.service.MenuService;
import com.atguigu.scw.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    AdminService adminService;

    //1 转发到登录页面的方法
    @RequestMapping("/login.html")
    public String loginPage(){
        return "admin/login";
    }

 /*   //2 处理登录请求的方法
    @RequestMapping(value = "/login" , method = RequestMethod.POST)
    public String login(HttpSession session, Model model, String loginacct , String userpswd){
        //接受参数时，由于数据要和数据库交互，建议变量名和数据库表的javabean的属性名一样
        //调用业务层处理业务
        TAdmin admin  = adminService.login(loginacct,userpswd);
        //判断登录结果
        if(admin==null){
            //登录失败,转发到登录页面
            String errorMsg = "账号或密码错误";
            model.addAttribute("errorMsg" , errorMsg);
            return "admin/login";
        }
        //登录成功：保持登录状态，重定向到成功页面
        session.setAttribute("admin" , admin);
        //重定向地址由浏览器解析，如果重定向的地址是WEB-INF下的，浏览器不能访问
        return "redirect:/admin/main.html";
    }
*/
    @Autowired
    MenuService menuService;

    //3、转发到登录成功页面的方法
    @RequestMapping("/main.html")
    public String mainPage(HttpSession session){
        //main.jsp页面需要显示左侧菜单栏，需要先查询菜单集合
        //查询已经设置了子菜单集合的父菜单集合
        List<TMenu> pMenus = menuService.getPMenus();
        //数据需要在多个页面中使用，需要共享到session中
        session.setAttribute("pmenus" , pMenus);
        //System.out.println("pMenus = " + pMenus);
        //转发到main页面时获取遍历菜单集合显示
        return "admin/main";
    }

  /*  //4、处理注销请求的方法
    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/admin/login.html";
    }*/

    //改造当前方法为带条件的分页查询：
    //5、查询管理员列表转发到管理员列表页面的方法
    @RequestMapping("/index")
    public String listUserList(HttpSession session,Model model,
                               @RequestParam(defaultValue = "1",required = false) Integer pageNum,
                                @RequestParam(defaultValue = "",required = false) String condition){
        int pageSize = 3;
        //指定分页查询：必须在业务执行之前
        //参数1：要查询分页数据的页码   参数2：查询分页数据时每页的记录数量
        PageHelper.startPage(pageNum,pageSize);

        //查询分页用户列表
        List<TAdmin> admins = adminService.getUserList(condition);
        //获取详细的分页对象：必须在业务查询之后
        // maven的配置：必须配置jdk的版本，如果是1.5的，后面的泛型必须写
        //参数1：分页查询的数据集合  参数2：页面需要显示的页码数量
        PageInfo<TAdmin> pageInfo = new PageInfo<>(admins,3);

        session.setAttribute("totalPage",pageInfo.getPages());
        session.setAttribute("currentPageNum",pageInfo.getPageNum());

        //存到request域共享
        model.addAttribute("pageInfo" , pageInfo);
        return "admin/user";
    }

    //6 转发到新增页面的方法
    @RequestMapping("/add.html")
    public String addPage(){
        return "admin/add";
    }

    //springsecurity通过注解可以在当前方法被访问前对用户的权限角色进行检查
    //注解内的值可以使用springel表达式，调用hasAnyRole或者hasAnyAuthority 传入方法需要的权限和角色
    //必须拥有hasAnyRole中的任意一个以上的角色 并且拥有hasAnyAuthority中的一个以上的权限才可以访问
    //@PreAuthorize("hasAnyRole('GL - 组长','BZR - 班主任','QA - 品质保证') and hasAnyAuthority('role:add')")
    //@PreAuthorize("hasAnyRole('GL - 组长','BZR - 班主任','QA - 品质保证') or hasAnyAuthority('role:add')")
    //@PreAuthorize("hasAnyAuthority('role:add', 'ROLE_GL - 组长','ROLE_BZR - 班主任','ROLE_QA - 品质保证')")

    //7 新增管理员的方法
    @RequestMapping(method = RequestMethod.POST,value = "/save")
    public String save(TAdmin admin,HttpSession session){
        try{
            adminService.saveAdmin(admin);
        }catch (Exception e){
            //新增失败：重定向到新增页面继续添加
            session.setAttribute("saveErrorMsg",e.getMessage());
            return "redirect:/admin/add.html";
        }

        Integer totalPage = (Integer) session.getAttribute("totalPage");
        //表单提交成功使用重定向，防止表单重复提交
        return "redirect:/admin/index?pageNum="+(totalPage+1);
    }

    //8、删除单个管理员
    @PreAuthorize("hasAnyAuthority('user:delete')")
    @RequestMapping(value = "/delete/{id}")
    public String delete(@PathVariable("id") Integer id, HttpSession session){
        adminService.deleteAdmin(id);
        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转到删除之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //9、处理批量删除的请求

    /**
     *  一个键多个值的提交方式：
     *         url?hobby=football&hobby=basketball&hobby=pingp
     *  springmvc中对参数提交进行了优化：
     *         入参类型：
     *         1、简单类型： 只要提交参数的key和方法的形参名一样就可以绑定入参
     *         2、对象类型：pojo，只要提交参数的key和pojo的属性名一样就可以绑定入参
     *              TAdmin：
     *                  String loginacct
     *                     Integer id
     *                 String email
     *         3、同一个键有多个值：使用List集合接受
     *              浏览器提交参数：url?ids=1,2,3,4
     *              springmvc接受时可以使用 @RequestParam("ids")List<Integer>ids
     */
    //集合类型的参数入参
    // url?id=1&id=2&id=3
    @RequestMapping(value = "/batchDelAdmins")
    public String batchDelAdmins(@RequestParam("ids")List<Integer> ids,HttpSession session){
        //System.out.println("ids = " + ids);
        adminService.batchDelAdmins(ids);
        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转到删除之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //10、转发到编辑管理员页面
    @RequestMapping("/edit.html")
    public String editPage(Integer id,Model model){
        //查询要更新的管理员数据
        TAdmin admin  = adminService.getAdmin(id);
        model.addAttribute("editAdmin" , admin);
        return "admin/edit";
    }

    //11、处理更新管理员的请求
    @RequestMapping(value = "update" , method = RequestMethod.POST)
    public String update(TAdmin admin,HttpSession session){
        adminService.updateAdmin(admin);
        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转回更新之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //12、转发到分配角色的页面

    @Autowired
    RoleService roleService;

    @RequestMapping("assignRole.html")
    public String assignRolePage(Model model , Integer id){
        //根据用户id查询他已分配和未分配的角色列表
        //已分配的角色：需要通过admin_role表和role表关联查询
        //未分配的角色：也需要两表 联查

        //查询所有的角色：只需要查询role表
        List<TRole> roles = roleService.getRoles(null);
        //查询该用户已分配的角色id列表：只需要查询admin_role表
        List<Integer> assignedRoleIds = roleService.getAssignedRoleIdsByAdminid(id);

        //将roles集合拆分为已分配的角色和未分配的角色集合存到域中
        List<TRole> unassignedRoles = new ArrayList<>();//未分配的角色列表
        List<TRole> assignedRoles = new ArrayList<>();//已分配的角色列表

        for (TRole role : roles) {
            if(assignedRoleIds.contains(role.getId())){
                //已分配的角色
                assignedRoles.add(role);
            }else{
                unassignedRoles.add(role);
            }
        }
        //存到request域
        model.addAttribute("assignedRoles",assignedRoles);
        model.addAttribute("unassignedRoles",unassignedRoles);

        return "admin/assignRole";
    }

    //13、处理异步分配角色请求的方法
    @ResponseBody
    @RequestMapping("assignRolesToAdmin")
    public String assignRolesToAdmin(Integer adminid , @RequestParam("roleids") List<Integer> roleids){
        roleService.assignRolesToAdmin(adminid,roleids);
        return "ok";
    }

    //14、处理异步删除管理员角色的方法
    @ResponseBody
    @RequestMapping("unassignRolesToAdmin")
    public String unassignRolesToAdmin(Integer adminid , @RequestParam("roleids") List<Integer> roleids ){
        roleService.unassignRolesToAdmin(adminid , roleids);
        return "ok";
    }

}
