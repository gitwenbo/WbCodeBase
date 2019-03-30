package com.jikexueyuan.rpc.serialize;

import com.jikexueyuan.rpc.exception.RpcException;

/**
 * Created on 2015/8/17.
 */
public interface Parser
{
    /**
     *
     * @param param ÇëÇó²ÎÊý
     * @return
     */
    Request reqParse(String param) throws RpcException;

    /**
     *
     * @param result
     * @return
     */
    public <T> T rsbParse(String result);
}
