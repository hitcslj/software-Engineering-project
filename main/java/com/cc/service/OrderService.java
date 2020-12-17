package com.cc.service;

import com.cc.model.OrderInfo;
import org.springframework.ui.Model;

import java.util.List;

public interface OrderService {
    /**
     *添加订单
     */
    boolean insertOrder(OrderInfo order);

    /**
     * 删除订单
     * @param id
     */
    boolean deleteOrder(Integer id);

    /**
     *  更新订单信息
     */
    boolean updateOrder(OrderInfo order);
    /**
     * 根据ID获取订单信息
     * @param id
     * @return
     */
    OrderInfo selectOrderById(Integer id);
    List<OrderInfo> selectOrderByType(String type);
    List<OrderInfo> selectOrderByState(String state);
    /**
     * 获取所有订单信息
     * @return
     */
    List<OrderInfo> selectAll();
    /**
     * 根据查询条件获取订单
     * @param orderInfo
     * @return
     */
    List<OrderInfo> selectOrdersByParams(OrderInfo orderInfo);

    OrderInfo selectOrderByCustomerName(String customerName);
    /**
     * 获取所有订单数量
     * @return
     */
   // int selectOrdersCount();
}
