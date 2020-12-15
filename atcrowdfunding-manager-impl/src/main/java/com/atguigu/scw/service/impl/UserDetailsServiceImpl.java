package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.*;
import com.atguigu.scw.mapper.TAdminMapper;
import com.atguigu.scw.mapper.TAdminRoleMapper;
import com.atguigu.scw.mapper.TPermissionMapper;
import com.atguigu.scw.mapper.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    TAdminMapper adminMapper;
    @Autowired
    TAdminRoleMapper adminRoleMapper;
    @Autowired
    TRoleMapper roleMapper;
    @Autowired
    TPermissionMapper permissionMapper;
    //根据账号加载主体对象
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        //根据账号查询t_admin表中的用户信息
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> admins = adminMapper.selectByExample(exa);
        if(CollectionUtils.isEmpty(admins)|| admins.size()>1){
            //账号不存在
            return null;
        }
        TAdmin admin = admins.get(0);
        //根据查询到的用户的id查询他的角色和权限名称集合
        Integer adminId = admin.getId();
        //查询角色名称集合
        TAdminRoleExample exa2 = new TAdminRoleExample();
        exa2.createCriteria().andAdminidEqualTo(adminId);
        List<TAdminRole> adminRoles = adminRoleMapper.selectByExample(exa2);
        //角色id集合
        List<Integer> roleids = new ArrayList<>();
        for (TAdminRole adminRole : adminRoles) {
            roleids.add(adminRole.getRoleid());
        }
        //将角色和权限名称封装为集合
        List<GrantedAuthority> authorities = new ArrayList<>();
        if(!CollectionUtils.isEmpty(roleids)){
            //角色名称集合
            TRoleExample exa3 = new TRoleExample();
            exa3.createCriteria().andIdIn(roleids);
            List<TRole> roles = roleMapper.selectByExample(exa3);
            List<String> rolenames = new ArrayList<>();
            for (TRole role : roles) {
                rolenames.add(role.getName());
            }
            //权限名称的集合
            List<String> permissionnames = permissionMapper.getPermissionNamesByRoleIds(roleids);

            for (String rolename : rolenames) {
                //角色名称封装时需要手动指定ROLE_前缀
                authorities.add(new SimpleGrantedAuthority("ROLE_"+rolename));
            }
            for (String permissionname : permissionnames) {
                authorities.add(new SimpleGrantedAuthority(permissionname));
            }
        }

        User user = new User(username, admin.getUserpswd(), authorities);
        System.out.println("主体对象 = " + user);
        //封装查询的数据为主体对象返回
        return user;
    }
}
