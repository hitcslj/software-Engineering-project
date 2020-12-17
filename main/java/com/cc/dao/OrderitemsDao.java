package com.cc.dao;

import com.cc.model.OrderInfo;
import com.cc.model.Orderitem;

import java.util.List;

public interface OrderitemsDao {
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

    void deleteOrderitem(Integer orderid);
}
