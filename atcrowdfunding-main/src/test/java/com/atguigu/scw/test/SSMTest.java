package com.atguigu.scw.test;

import com.atguigu.scw.bean.TMenu;
import com.atguigu.scw.mapper.TMenuMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

/**
 * web项目在tomcat中部署运行时，spring容器对象创建的原因？
 *      通过web的三大组件：Listener，Servlet，当服务器启动时会自动从webxml中根据配置的组件的全类名反射创建组件的对象
 *      ，调用对象的生命周期方法，在它的方法中完成的spring容器的初始化
 *
 *      在服务器运行期间，可以通过自动装配的方式从容器中装配对象使用。
 */
//通过springtest，在测试方法执行之前创建指定spring配置文件的容器对象

@RunWith(SpringRunner.class)    //指定使用Spring的测试类执行测试代码
@ContextConfiguration(locations = {"classpath:spring/spring-*.xml"})
public class SSMTest {
    //测试ssm整合
    @Autowired
    TMenuMapper menuMapper;
    @Test
    public void test(){
        List<TMenu> tMenus = menuMapper.selectByExample(null);
        System.out.println("tMenus = " + tMenus);
    }
}
