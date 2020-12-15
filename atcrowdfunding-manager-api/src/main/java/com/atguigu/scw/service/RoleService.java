package com.atguigu.scw.service;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.bean.TRole;

import java.util.List;

public interface RoleService {
    List<TRole> getRoles(String condition);

    void deleteRole(Integer id);

    void batchDelRoles(List<Integer> ids);

    void addRole(TRole role);

    TRole getRole(Integer id);

    void updateRole(TRole role);

    List<Integer> getAssignedRoleIdsByAdminid(Integer id);

    void assignRolesToAdmin(Integer adminid, List<Integer> roleids);

    void unassignRolesToAdmin(Integer adminid, List<Integer> roleids);

    List<TPermission> getPermissions();

    List<Integer> getAssignedPermissionids(Integer roleid);

    void deletePermissionidsByRoleid(Integer roleid);

    void assignPermissionsToRole(Integer roleid, List<Integer> permissionids);
}
