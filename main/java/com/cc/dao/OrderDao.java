package com.cc.dao;
import com.cc.model.OrderInfo;

import java.util.List;

public interface OrderDao {
     /**
      * 添加订单
      * @param  order
      */
    void addOrder(OrderInfo order);

    /**
     * 删除订单
     * @param id
     */
    void deleteOrder(Integer id);

    /**
     * 修改订单信息
     * @param orderInfo
     */
    void updateOrder(OrderInfo orderInfo);
    /**
     * 根据ID获取订单信息
     * @param id
     * @return
     */
    OrderInfo selectOrderById(int id);

    /**
     * 根据商品名获取
     * @param
     * @return
     */
    OrderInfo selectOrderByCustomerName(String Name);

    /**
     * 获取指定类型的批发单
     * @param type
     * @return
     */
    List<OrderInfo> selectOrderByType(String type);
    /**
     * 获取订单所有信息
     * @return
     */
    /**
     * 根据状态获取订单
     * @param state
     * @return
     */
    List<OrderInfo> selectOrderByState(String state);
    List<OrderInfo> selectAll();
    /**
     * 根据查询条件获取订单
     * @param orderInfo
     * @return
     */
    List<OrderInfo> selectOrderByParams(OrderInfo orderInfo);
}
