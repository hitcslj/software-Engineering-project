package com.cc.service.Impl;

import com.cc.dao.ItemsInfoDao;
import com.cc.model.ItemsInfo;
import com.cc.service.ItemsInfoService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service("itemsInfoService")
public class ItemsInfoServiceImpl implements ItemsInfoService {
    @Resource
    private ItemsInfoDao itemsInfoDao;

    public void insertItems(ItemsInfo items) {

        itemsInfoDao.insertItems(items);
        System.out.println(items.getName()+items.getPrice()+items.getNumber());
    }

    public void deleteItems(int id) {
        itemsInfoDao.deleteItems(id);
    }

    public void updateItems(ItemsInfo items) {itemsInfoDao.updateItems(items);
    }

    public ItemsInfo selectItemsById(int id) {
        return itemsInfoDao.selectItemsById(id);
    }

    public List<ItemsInfo> selectAll() {
        return itemsInfoDao.selectAll();
    }

    public List<ItemsInfo> selectItemsByItemsName(String Name) {
        return itemsInfoDao.selectItemsByItemsName(Name);
    }

    @Override
    public ItemsInfo selectItemsByItemsNameAndLocation(String Name, String Location) {
         return itemsInfoDao.selectItemsByItemsNameAndLocation(Name, Location);
    }

    @Override
    public List<ItemsInfo> selectItemsByLocation(String location) {
         return  itemsInfoDao.selectItemsByLocation(location);
    }

    public List<ItemsInfo> selectItemsByParams(ItemsInfo itemsInfo) {
        return itemsInfoDao.selectItemsByParams(itemsInfo);
    }

    public int selectItemsCount() {
        return itemsInfoDao.selectItemsCount();
    }
}

