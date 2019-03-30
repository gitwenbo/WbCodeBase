package RestfulTest;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.MediaType;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.xml.Jaxb2RootElementHttpMessageConverter;

import java.util.ArrayList;
import java.util.List;

public class WxMappingJackson2HttpMessageConverter extends MappingJackson2HttpMessageConverter {
    public WxMappingJackson2HttpMessageConverter() {
        List<MediaType> mediaTypes = new ArrayList<>();
        mediaTypes.add(MediaType.TEXT_PLAIN);
        mediaTypes.add(MediaType.TEXT_HTML);  //加入text/html类型的支持
        setSupportedMediaTypes(mediaTypes);// tag6
    }

//    protected List<HttpMessageConverter<?>> httpMessageConverters() {
//        List<HttpMessageConverter<?>> httpMessageConverters = new ArrayList<>();
//        httpMessageConverters.add(new StringHttpMessageConverter());
//        httpMessageConverters.add(new FormHttpMessageConverter());
//        httpMessageConverters.add(new Jaxb2RootElementHttpMessageConverter());
//
//        // json properties relaxed rule by tech cop.
//        MappingJackson2HttpMessageConverter jackson2Converter = new MappingJackson2HttpMessageConverter();
//        ObjectMapper objectMapper = jackson2Converter.getObjectMapper();
//        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
////        objectMapper.registerModule(new Jackson1CompatibilityModule());
//        httpMessageConverters.add(jackson2Converter);
//
//        return httpMessageConverters;
//    }
}
