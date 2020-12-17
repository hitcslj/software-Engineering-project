package com.cc.model;

import com.cc.dao.ItemsInfoDao;
import com.cc.dao.OrderitemsDao;

public class OrderInfo {
    private Integer id;
    private String itemsName = "";
    private String itemsNumber="";
    private String itemsPrice = "";
    private Integer totalPrice = 1;
    private String state = "";
    private String customerName  = "";
    private String telephone = "";
    private String type;
    private Integer startRow = 0;
    private Integer endRow=2;
    private Integer inPrice;
    public Integer getInPrice() {
        return inPrice;
    }

    public void setInPrice(Integer inPrice) {
        this.inPrice = inPrice;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getItemsName() {
        return itemsName;
    }

    public void setItemsName(String itemsName) {
        this.itemsName = itemsName;
    }
    public String getItemsNumber() {
        return itemsNumber;
    }

    public void setItemsNumber(String itemsNumber) {
        this.itemsNumber = itemsNumber;
    }
    public String getItemsPrice() {
        return itemsPrice;
    }

    public void setItemsPrice(String itemsPrice) {
        this.itemsPrice = itemsPrice;
    }

    public Integer getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Integer totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Integer getStartRow() {
        return startRow;
    }

    public void setStartRow(Integer startRow) {
        this.startRow = startRow;
    }

    public Integer getEndRow() {
        return endRow;
    }

    public void setEndRow(Integer endRow) {
        this.endRow = endRow;
    }

    /***
     * 打个补丁，现在你们如果改DAO或SERVICE必须要注意这里
     */
    public OrderInfo updatedata(OrderitemsDao orderitemsDao,ItemsInfoDao itemsInfoDao)
    {
        String itemsName = "";
        String itemsNumber= "";
        String itemsPrice = "";
        Integer totalPrice = 0;
        Integer inPrice = 0;
        for(Orderitem a:orderitemsDao.getItemidByOrderid(this.getId()))//用订单id在数据库中查询
        {
            ItemsInfo t = itemsInfoDao.selectItemsById(a.getItemid());//商品id获得
            //a是订单项，t是商品项
            if(t==null)return this;
            itemsName+=" "+t.getName();
            itemsNumber+=" "+a.getItemnum();

            if(this.getType().equals("trade"))
            {totalPrice+=t.getTradeprice()*a.getItemnum();
                itemsPrice+= " "+t.getTradeprice();
            }
            else
            {totalPrice+=t.getPrice()*a.getItemnum();
                itemsPrice+= " "+t.getPrice();}
            inPrice+=t.getInprice()*a.getItemnum();
        }
        this.itemsName = itemsName.trim();
        this.itemsNumber = itemsNumber.trim();
        this.itemsPrice = itemsPrice.trim();
        this.totalPrice = totalPrice;
        this.inPrice = inPrice;
        System.out.println(totalPrice);
        System.out.println(inPrice);
        return this;
    }
}
