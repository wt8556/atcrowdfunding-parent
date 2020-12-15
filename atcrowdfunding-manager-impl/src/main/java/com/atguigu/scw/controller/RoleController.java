package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/role")
public class RoleController {

    @Autowired
    RoleService roleService;

    //10、处理异步权限分配的请求
    @ResponseBody
    @RequestMapping("assignPermissionsToRole")
    public String assignPermissionsToRole(Integer roleid ,
                                          @RequestParam(value = "permissionids" ,required = false) List<Integer> permissionids){
        //由于前台提交的请求可能是取消分配也可能是分配权限的请求，后台处理时先删除所有的权限，然后再新增
        roleService.deletePermissionidsByRoleid(roleid);
        if(!CollectionUtils.isEmpty(permissionids)){
            //将传入的permissionids分配给角色
            roleService.assignPermissionsToRole(roleid , permissionids);
        }
        return "ok";
    }

    //9、处理异步查询已分配权限id集合的方法
    @ResponseBody
    @RequestMapping("getAssignedPermissionids")
    public List<Integer> getAssignedPermissionids(Integer roleid){
        return roleService.getAssignedPermissionids(roleid);
    }

    //8、处理异步加载所有权限列表的方法
    @ResponseBody
    @RequestMapping("getPermissions")
    public List<TPermission> getPermissions(){
        return roleService.getPermissions();
    }

    //7 处理异步更新角色的方法
    @ResponseBody
    @RequestMapping("/updateRole")
    public String updateRole(TRole role){
        roleService.updateRole(role);
        return "ok";
    }

    //6 处理异步查询要更新的角色信息的方法
    @ResponseBody
    @RequestMapping("/getRole")
    public TRole getRole(Integer id){
        return roleService.getRole(id);
    }

    //5 处理异步新增请求的方法
    @ResponseBody
    @RequestMapping("/addRole")
    public String addRole(TRole role){
        roleService.addRole(role);
        return "ok";
    }

    //4 批量删除
    @ResponseBody
    @RequestMapping("/batchDelRoles")
    public String batchDelRoles(@RequestParam("ids") List<Integer> ids){
        roleService.batchDelRoles(ids);
        return "ok";
    }

    //3 处理异步删除指定角色的方法
    @ResponseBody
    @RequestMapping("/delete")
    public String delete(Integer id){
        roleService.deleteRole(id);
        //返回"ok"代表操作成功，"fail"代表失败
        return "ok";
    }

    //2 异步查询角色列表的方法：带条件的分页查询，返回分页对象
    @ResponseBody
    @RequestMapping("/getRoles")
    public PageInfo<TRole> getRoles(@RequestParam(defaultValue = "1",required = false) Integer pageNum,
                                    @RequestParam(defaultValue = "",required = false) String condition){
        int pageSize = 3;
        //查询业务之前，指定使用分页查询
        PageHelper.startPage(pageNum,pageSize);
        //执行查询业务
        List<TRole> roles = roleService.getRoles(condition);
        //获取详细的分页对象
        PageInfo<TRole> pageInfo = new PageInfo<>(roles,3);
        return pageInfo;
    }

    //1 转发到role.jsp页面的方法
    @RequestMapping("/index")
    public String rolePage(){
        return "role/role";
    }

}
