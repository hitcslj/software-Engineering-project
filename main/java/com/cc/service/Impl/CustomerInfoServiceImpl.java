package com.cc.service.Impl;

import com.cc.dao.CustomerInfoDao;
import com.cc.model.CustomerInfo;
import com.cc.service.CustomerInfoService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service("customerInfoService")
public class CustomerInfoServiceImpl implements CustomerInfoService {
    @Resource
    private CustomerInfoDao customerInfoDao;

    public void insertCustomer(CustomerInfo customer) {
        customerInfoDao.insertCustomer(customer);
    }

    public void deleteCustomer(int id) {
        customerInfoDao.deleteCustomer(id);
    }

    public void updateCustomer(CustomerInfo customer) {
        customerInfoDao.updateCustomer(customer);
    }

    public CustomerInfo selectCustomerById(int id) {
        return customerInfoDao.selectCustomerById(id);
    }

    public List<CustomerInfo> selectAll() {
        return customerInfoDao.selectAll();
    }

    public CustomerInfo selectCustomerByName(String Name) {
        return customerInfoDao.selectCustomerByName(Name);
    }

    public List<CustomerInfo> selectCustomerByParams(CustomerInfo customerInfo) {
        return customerInfoDao.selectCustomerByParams(customerInfo);
    }
    public int selectCustomerCount() {
        return customerInfoDao.selectCustomerCount();
    }
}

