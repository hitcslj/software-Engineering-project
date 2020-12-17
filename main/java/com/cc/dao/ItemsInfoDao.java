package com.cc.dao;

import com.cc.model.ItemsInfo;
import com.cc.model.ItemsInfo;

import java.util.List;

public interface ItemsInfoDao {
    /**
     *添加商品信息
     * @param itemsInfo
     */
    void insertItems(ItemsInfo itemsInfo);

    /**
     * 删除商品
     * @param id
     */
    void deleteItems(int id);

    /**
     * 修改商品信息
     * @param itemsInfo
     */
    void updateItems(ItemsInfo itemsInfo);
    /**
     * 根据ID获取商品信息
     * @param id
     * @return
     */
    ItemsInfo selectItemsById(int id);
    /**
     * 获取所有商品信息
     * @return
     */
    List<ItemsInfo> selectAll();

    /**
     * 根据商品名获取
     * @param
     * @return
     */
   List<ItemsInfo> selectItemsByItemsName(String Name);

    ItemsInfo selectItemsByItemsNameAndLocation(String Name, String Location);
    List<ItemsInfo> selectItemsByLocation(String Location);
    /**
     * 根据查询条件获取
     * @param itemsInfo
     * @return
     */
    List<ItemsInfo> selectItemsByParams(ItemsInfo itemsInfo);
    /**
     * 获取所有商品数量
     * @return
     */
    int selectItemsCount();
}

