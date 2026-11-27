package com.medicine.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5加密工具类
 */
public class MD5Util {

    /**
     * 对字符串进行MD5加密
     * @param input 原始字符串
     * @return MD5加密后的32位小写字符串
     */
    public static String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }

    /**
     * 验证密码
     */
    public static boolean verify(String input, String encrypted) {
        return md5(input).equals(encrypted);
    }
}
