package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.*;
import com.atguigu.scw.mapper.TAdminRoleMapper;
import com.atguigu.scw.mapper.TPermissionMapper;
import com.atguigu.scw.mapper.TRoleMapper;
import com.atguigu.scw.mapper.TRolePermissionMapper;
import com.atguigu.scw.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    TRoleMapper roleMapper;

    @Override
    public List<TRole> getRoles(String condition) {
        if (StringUtils.isEmpty(condition)){
            return roleMapper.selectByExample(null);
        }

        TRoleExample exa = new TRoleExample();
        exa.createCriteria().andNameLike("%" + condition + "%");
        return roleMapper.selectByExample(exa);
    }

    @Override
    public void deleteRole(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDelRoles(List<Integer> ids) {
        TRoleExample exa = new TRoleExample();
        exa.createCriteria().andIdIn(ids);
        roleMapper.deleteByExample(exa);
    }

    @Override
    public void addRole(TRole role) {
        roleMapper.insertSelective(role);
    }

    @Override
    public TRole getRole(Integer id) {
        return roleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }

    @Autowired
    TAdminRoleMapper adminRoleMapper;
    @Override
    public List<Integer> getAssignedRoleIdsByAdminid(Integer id) {//中间表admin_role表
        TAdminRoleExample exa = new TAdminRoleExample();
        exa.createCriteria().andAdminidEqualTo(id);
        List<TAdminRole> adminRoles = adminRoleMapper.selectByExample(exa);
        List<Integer> roleIds = new ArrayList<>();
        for (TAdminRole adminRole : adminRoles) {
            roleIds.add(adminRole.getRoleid());
        }
        return roleIds;
    }

    @Override
    public void assignRolesToAdmin(Integer adminid, List<Integer> roleids) {
        //只需要将adminid和roleids存到t_admin_role表中即可   adminid:2 , roleids :3 , 4,5
        // insert into t_admin_role(adminid , roleid)  values(2,3),(2,4),(2,5)
        adminRoleMapper.batchInsertAdminRoles(adminid, roleids);
    }

    @Override
    public void unassignRolesToAdmin(Integer adminid, List<Integer> roleids) {
        //delete from t_admin_role where adminid = 2 and roleid in (roleids);
        TAdminRoleExample exa = new TAdminRoleExample();
        exa.createCriteria().andAdminidEqualTo(adminid).andRoleidIn(roleids);
        adminRoleMapper.deleteByExample(exa);
    }

    @Autowired
    TPermissionMapper permissionMapper;
    @Override
    public List<TPermission> getPermissions() {
        return permissionMapper.selectByExample(null);
    }

    @Autowired
    TRolePermissionMapper rolePermissionMapper;
    @Override
    public List<Integer> getAssignedPermissionids(Integer roleid) {
        TRolePermissionExample exa = new TRolePermissionExample();
        exa.createCriteria().andRoleidEqualTo(roleid);
        List<TRolePermission> rolePermissions = rolePermissionMapper.selectByExample(exa);

        ArrayList<Integer> assignedPermissionids = new ArrayList<>();
        for (TRolePermission rolePermission : rolePermissions) {
            assignedPermissionids.add(rolePermission.getPermissionid());
        }
        return assignedPermissionids;
    }

    @Override
    public void deletePermissionidsByRoleid(Integer roleid) {
        TRolePermissionExample exa = new TRolePermissionExample();
        exa.createCriteria().andRoleidEqualTo(roleid);
        rolePermissionMapper.deleteByExample(exa);
    }

    @Override
    public void assignPermissionsToRole(Integer roleid, List<Integer> permissionids) {
//        for (Integer permissionid : permissionids) {
//            rolePermissionMapper.insertSelective(new TRolePermission())
//        }
        rolePermissionMapper.batchInsertRolePermission(roleid , permissionids);
    }
}
