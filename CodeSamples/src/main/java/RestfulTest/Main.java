package RestfulTest;

import com.google.common.collect.Lists;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {

        System.out.println(pickTargetItem(Lists.newArrayList(364546446l,441075237l)));

    }

    public static Long pickTargetItem(List<Long> itemIds) {
        RestTemplate matchingRestTemplate = new RestTemplate();
        matchingRestTemplate.getMessageConverters().add(new WxMappingJackson2HttpMessageConverter());

        ParameterizedTypeReference<Long> returnType = new ParameterizedTypeReference<Long>() {
        };
        ResponseEntity<Long> responseEntity;
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Request-Auth", "8d001d97-bfd3-45a5-8363-64e75bb36029");
        HttpEntity<List<Long>> entity = new HttpEntity<List<Long>>(itemIds, headers);
        try {
            String hosturl = "http://post-dedup-matching.coupang.net/api/v1/matching/item/pick-target";
            responseEntity = matchingRestTemplate.exchange(hosturl, HttpMethod.POST, entity, returnType);
        } catch (RuntimeException e) {
            throw e;
        }
        return responseEntity.getBody();
    }

}
