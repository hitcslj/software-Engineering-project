package com.cc.model;

public class Orderitem {
    private Integer id;
    private Integer orderid;
    private Integer itemid;
    private Integer itemnum;
    public Orderitem(Integer orderid, Integer itemid, Integer itemnum) {
        this.orderid = orderid;
        this.itemid = itemid;
        this.itemnum = itemnum;
    }
    public Orderitem(Long id,Long orderid,Long itemid,Long itemnum) {
        this.id = id.intValue();
        this.orderid = orderid.intValue();
        this.itemid = itemid.intValue();
        this.itemnum = itemnum.intValue();
    }
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderid() {
        return orderid;
    }

    public void setOrderid(Integer orderid) {
        this.orderid = orderid;
    }

    public Integer getItemid() {
        return itemid;
    }

    public void setItemid(Integer itemid) {
        this.itemid = itemid;
    }

    public Integer getItemnum() {
        return itemnum;
    }

    public void setItemnum(Integer itemnum) {
        this.itemnum = itemnum;
    }




}
