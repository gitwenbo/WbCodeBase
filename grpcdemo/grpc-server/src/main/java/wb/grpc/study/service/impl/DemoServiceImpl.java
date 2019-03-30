package wb.grpc.study.service.impl;

import io.grpc.stub.StreamObserver;
import wb.grpc.study.dto.*;
import wb.grpc.study.service.DemoServiceGrpc;

import java.util.ArrayList;
import java.util.List;


public class DemoServiceImpl implements DemoServiceGrpc.DemoService {
    public void ping(PingRequest pingRequest, StreamObserver<PingResponse> streamObserver) {
        PingResponse reply = PingResponse.newBuilder().setOut("pong => " + pingRequest.getIn()).build();
        streamObserver.onValue(reply);
        streamObserver.onCompleted();
    }

    public void getPersonList(QueryParameter queryParameter, StreamObserver<PersonList> streamObserver) {
        //System.out.println(queryParameter.getAgeStart() + "-" + queryParameter.getAgeEnd());
        PersonList.Builder personListBuilder = PersonList.newBuilder();
        Person.Builder builder = Person.newBuilder();
        List<Person> list = new ArrayList<Person>();
        for (short i = 0; i < 10; i++) {
            list.add(builder.setAge(i).setChildrenCount(i).setName("test" + i).setSex(true).build());
        }
        personListBuilder.addAllItems(list);
        streamObserver.onValue(personListBuilder.build());
        streamObserver.onCompleted();
    }
}