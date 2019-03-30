package com.jikexueyuan.rpc.serialize;

/**
 * Created on 2015/8/17.
 */
public interface Formater
{
    /**
     *
     * @param clazz ����Ľӿ�
     * @param method ����ķ���
     * @param param ����Ĳ���
     * @return
     */
    String reqFormat(Class clazz, String method, Object param);

    /**
     *
     * @param param ��Ӧ�Ľ��
     * @return
     */
    String rsbFormat(Object param);
}
