package com.atguigu.scw.service.impl;

import com.atguigu.scw.bean.TAdmin;
import com.atguigu.scw.bean.TAdminExample;
import com.atguigu.scw.mapper.TAdminMapper;
import com.atguigu.scw.service.AdminService;
import com.atguigu.scw.utils.DateUtil;
import com.atguigu.scw.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.util.unit.DataUnit;

import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    TAdminMapper adminMapper;

    @Override
    public TAdmin login(String loginacct, String userpswd) {
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(loginacct).andUserpswdEqualTo(MD5Util.digest(userpswd));
        List<TAdmin> admins = adminMapper.selectByExample(exa);
        if (CollectionUtils.isEmpty(admins) || admins.size()>1){
            //如果没有查询到或者查询超过一个管理员，都认为查询失败
            return null;
        }
        TAdmin admin = admins.get(0);
        return admin;
    }

    @Override
    public List<TAdmin> getUserList(String condition) {
        //如果有条件则带条件查询分页的数据： select * from t_admin where xxx like '' limit index ,size
        //如果没有条件则查询所有数据的分页数据： select * from t_admin like '' limit index ,size
        if (StringUtils.isEmpty(condition)){
            return adminMapper.selectByExample(null);
        }

        TAdminExample exa = new TAdminExample();
        //select * from t_admin where loginacct like '%xxx%' or username like '%xxx%' or
                                                   //                       email like '%xxx%' limit index,size
        TAdminExample.Criteria c1 = exa.createCriteria();
        c1.andLoginacctLike("%" + condition + "%");
        TAdminExample.Criteria c2 = exa.createCriteria();
        c2.andUsernameLike("%" + condition + "%");
        TAdminExample.Criteria c3 = exa.createCriteria();
        c3.andEmailLike("%" + condition +"%");
        exa.or(c2);
        exa.or(c3);
        return adminMapper.selectByExample(exa);
    }

    @Override
    public void saveAdmin(TAdmin admin) {
        //账号邮箱唯一性校验（前台一般也会使用ajax校验）
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(admin.getLoginacct());
        long loginacctCount = adminMapper.countByExample(exa);
        if (loginacctCount>0){
            //账号已占用
            throw new RuntimeException("账号被占用");
        }
        exa.clear();
        exa.createCriteria().andEmailEqualTo(admin.getEmail());
        long emailCount = adminMapper.countByExample(exa);
        if (emailCount>0){
            //邮箱已占用
            throw new RuntimeException("邮箱被占用");
        }

        //初始化其他的数据
        admin.setCreatetime(DateUtil.getFormatTime());
        //密码加密保存，登录使用加密密码
        admin.setUserpswd(MD5Util.digest(admin.getUserpswd()));
        adminMapper.insertSelective(admin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDelAdmins(List<Integer> ids) {
        //delete from t_admin where id in (1,2,3,4);
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andIdIn(ids);
        adminMapper.deleteByExample(exa);
    }

    @Override
    public TAdmin getAdmin(Integer id) {
        return adminMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateAdmin(TAdmin admin) {
        /**
         * 账号和邮箱的唯一性校验
         *  步骤：
         *          1、admin包含了管理员id，可以根据id查询数据库中的admin记录
         *      2、使用浏览器提交的修改后的admin和数据库的admin比较：如果账号和邮箱一样不用验证
         *      3、如果账号 或 邮箱不一致，需要校验唯一性：根据账号或邮箱去数据库查询记录条数，有代表被占用
         *
         */
        adminMapper.updateByPrimaryKeySelective(admin);
    }
}
