package com.atguigu.scw.controller;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.mapper.TMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DispatcherController {

    //1、转发到首页的方法
    @RequestMapping(value = {"/" , "/index" , "/index.html"},method = RequestMethod.GET)
    public String index(){
        //返回视图名称
        return "index";//视图名称由视图解析器解析，自动拼接前后缀：/WEB-INF/pages/index.jsp
    }

   /* //自动装配Mapper
    @Autowired
    TMenuMapper menuMapper;
    @ResponseBody
    @RequestMapping("/getMenus")
    public List<TMenu> getMenus(){
        return menuMapper.selectByExample(null);
    }*/
}
