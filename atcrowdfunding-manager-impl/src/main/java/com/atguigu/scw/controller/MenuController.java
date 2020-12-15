package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    MenuService menuService;

    //6 查询指定id的菜单的请求
    @ResponseBody
    @RequestMapping("/getMenu")
    public TMenu getMenu(Integer id){
        return menuService.getMenu(id);
    }

    //5 异步更新菜单的请求
    @ResponseBody
    @RequestMapping("/updateMenu")
    public String  updateMenu(TMenu menu){
        menuService.updateMenu(menu);
        return "ok";
    }

    //4 处理异步删除菜单的请求
    @PreAuthorize("hasAnyRole('PM - 项目经理')")
    @ResponseBody
    @RequestMapping("/deleteMenu")
    public String deleteMenu(Integer id){
        menuService.deleteMenu(id);
        return "ok";
    }

    //3 处理异步新增菜单的请求
    @ResponseBody
    @RequestMapping("/addMenu")
    public String addMenu(TMenu menu){
        menuService.addMenu(menu);
        return "ok";
    }

    //2 异步查询菜单集合的方法
    @ResponseBody
    @RequestMapping("/getMenus")
    public List<TMenu> getMenus(){
        return menuService.getPMenus();
    }


    //1 转发到menu页面
    @RequestMapping("/index")
    public String menuPage(){
        return "menus/menu";
    }
}
