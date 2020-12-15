package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.mapper.TMenuMapper;
import com.atguigu.scw.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService {

    @Autowired
    TMenuMapper menuMapper;

    @Override
    public List<TMenu> getPMenus() {
        //先查询所有的菜单
        List<TMenu> menus = menuMapper.selectByExample(null);
        //挑出父菜单集合
        Map<Integer,TMenu> pmenus = new HashMap<>();
        for (TMenu menu : menus) {
            if (menu.getPid() == 0){
                pmenus.put(menu.getId(),menu);
            }
        }
        /* 遍历所有的菜单，如果正在遍历的菜单的pid和父菜单集合的某个菜单的id一样，
           那么就是他的子菜单，将子菜单设置给父菜单的子菜单集合属性就可以*/
        for (TMenu menu : menus) {
            if (menu.getPid() != 0){ //pid除了0之外，一定会对应一个父菜单的id值
                TMenu pmenu = pmenus.get(menu.getPid());
                if (pmenu != null){
                    pmenu.getChildren().add(menu);
                }
            }
        }
        //返回父菜单集合
        return new ArrayList<TMenu>(pmenus.values());
    }

    @Override
    public void addMenu(TMenu menu) {
        menuMapper.insertSelective(menu);
    }

    @Override
    public void deleteMenu(Integer id) {
        menuMapper.deleteByPrimaryKey(id);
    }

    @Override
    public TMenu getMenu(Integer id) {
        return menuMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateMenu(TMenu menu) {
        menuMapper.updateByPrimaryKeySelective(menu);
    }
}
