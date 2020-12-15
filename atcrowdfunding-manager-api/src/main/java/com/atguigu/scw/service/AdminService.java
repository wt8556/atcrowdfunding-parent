package com.atguigu.scw.service;

import com.atguigu.scw.bean.TAdmin;

import java.util.List;

public interface AdminService {
     TAdmin login(String loginacct, String userpswd);

    List<TAdmin> getUserList(String condition);

    void saveAdmin(TAdmin admin);

    void deleteAdmin(Integer id);

    void batchDelAdmins(List<Integer> ids);

    TAdmin getAdmin(Integer id);

    void updateAdmin(TAdmin admin);
}
