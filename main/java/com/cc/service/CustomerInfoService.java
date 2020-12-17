package com.cc.service;

import com.cc.model.CustomerInfo;

import java.util.List;

public interface CustomerInfoService {
    /**
     *添加客户信息
     * @param customer
     */
    void insertCustomer(CustomerInfo customer);

    /**
     * 删除客户
     * @param id
     */
    void deleteCustomer(int id);

    /**
     * 修改客户信息
     * @param customer
     */
    void updateCustomer(CustomerInfo customer);
    /**
     * 根据ID获取客户信息
     * @param id
     * @return
     */
    CustomerInfo selectCustomerById(int id);
    /**
     * 获取所有客户信息
     * @return
     */
    List<CustomerInfo> selectAll();
    /**
     * 根据名获取客户
     * @param
     * @return
     */
    CustomerInfo selectCustomerByName(String Name);

    /**
     * 根据查询条件获取客户
     * @param customerInfo
     * @return
     */
    List<CustomerInfo> selectCustomerByParams(CustomerInfo customerInfo);

    /**
     * 获取所有客户数量
     * @return
     */
    int selectCustomerCount();
}

