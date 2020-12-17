package com.cc.service;

import com.cc.model.ItemsInfo;

import java.util.List;

public interface ItemsInfoService {
    /**
     *添加商品信息
     * @param items
     */
    void insertItems(ItemsInfo items);

    /**
     * 删除商品
     * @param id
     */
    void deleteItems(int id);

    /**
     * 修改商品信息
     * @param items
     */
    void updateItems(ItemsInfo items);
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

    /**
     * 获取指定仓库的指定商品
     * @param Name
     * @param Location
     * @return
     */
    ItemsInfo selectItemsByItemsNameAndLocation(String Name, String Location);

    /**
     * 获取某一仓库商品
     * @param location
     * @return
     */
    List<ItemsInfo> selectItemsByLocation(String location);
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

