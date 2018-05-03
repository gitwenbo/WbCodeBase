package com.wb.domain.repository;

import com.mysema.query.jpa.impl.JPAQuery;
import com.mysema.query.jpa.sql.JPASQLQuery;
import com.mysema.query.sql.SQLTemplates;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.sql.DataSource;

public class WbJpaQueryBuilder {

    @PersistenceContext(unitName = "postdedup")
    private EntityManager entityManager;

    @Autowired
    private DataSource wbDatasource;

    @Autowired
    private SQLTemplates sqlTemplates;

    public JPAQuery getJpaQuery() {
        return new JPAQuery(entityManager);
    }

    public JPASQLQuery getJPASQLQuery() {
        return new JPASQLQuery(entityManager, sqlTemplates);
    }
}
