package com.atguigu.scw.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class TMenu implements Serializable {
    private Integer id;

    private Integer pid;

    private String name;

    private String icon;

    private String url;

    public List<TMenu> getChildren() {
        return children;
    }

    public void setChildren(List<TMenu> children) {
        this.children = children;
    }

    //如果当前菜单是父菜单，children表示父菜单的子菜单集合
    private List<TMenu> children = new ArrayList<>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon == null ? null : icon.trim();
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url == null ? null : url.trim();
    }

    @Override
    public String toString() {
        return "TMenu{" +
                "id=" + id +
                ", pid=" + pid +
                ", name='" + name + '\'' +
                ", icon='" + icon + '\'' +
                ", url='" + url + '\'' +
                ", children=" + children +
                '}';
    }
}