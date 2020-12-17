package com.cc.model;

import java.util.List;

/**
 * 分页工具类
 */
public class PageUtil {
    /**
     * 当前页 默认为1
     */
    private int currentPage=1;

    /**
     * 每页显示的记录数  默认为10条
     */
    private int pageSize = 10;

    /**
     * 总页数
     */
    private int totalPage;

    /**
     * 总记录数
     */
    private int totalRecord;

    /**
     * 起始记录
     */
    private int startRow;

    /**
     * 终止记录
     */
    private int endRow;

    /**
     * 上一页
     */
    private int upPage;

    /**
     * 下一页
     */
    private int downPage;

    /**
     * 访问路径
     */
    private String accessUrl;

    /**
     * 页面需要显示的数据集合
     */
    private List objectLists;


    /**
     * 当前页页码
     *
     * @param currentPage
     */
    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }
    public int getCurrentPage() {
        return currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    /**
     * 总页数，根据总记录数计算得出
     *
     * @return
     */
    public int getTotalPage() {
        return this.totalRecord % this.pageSize == 0 ? this.totalRecord
                / this.pageSize : (this.totalRecord / this.pageSize) + 1;
    }
    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }
    /**
     * 总记录数
     *
     * @return
     */
    public int getTotalRecord() {
        return totalRecord;
    }

    public void setTotalRecord(int totalRecord) {
        this.totalRecord = totalRecord;
    }

    /**
     * 起始记录行
     *
     * @return
     */
    public int getStartRow() {
        return (this.currentPage - 1) * this.pageSize;
    }

    /**
     * 结束记录行
     *
     * @return
     */
    public int getEndRow() {
        return this.currentPage * this.pageSize;
    }

    /**
     * 上一页
     *
     * @return
     */
    public int getUpPage() {
        return (this.currentPage == 1) ? 1 : (this.currentPage - 1);
    }

    /**
     * 下一页
     *
     * @return
     */
    public int getDownPage() {
        return (this.currentPage == this.totalPage) ? this.totalPage
                : (this.currentPage + 1);
    }

    /*
     * 结果记录集
     */
    public List getObjectLists() {
        return objectLists;
    }

    public void setObjectLists(List objectLists) {
        this.objectLists = objectLists;
    }

}

