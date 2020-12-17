package com.cc.service;

import com.cc.model.Orderitem;

import java.util.List;

public interface OrderitemsService {
    /**
     * 添加订单项
     */
    void addOrderitem(Orderitem oi);
    /**
     * 按照订单id查找项目id
     * @param orderid
     * @return
     */
    List<Orderitem> getItemidByOrderid(Integer orderid);
}
