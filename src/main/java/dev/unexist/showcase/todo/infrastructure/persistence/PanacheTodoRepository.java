/**
 * @package Quarkus-Kubernetes-Showcase
 *
 * @file Todo postgres repository
 * @copyright 2020-2021 Christoph Kappel <christoph@unexist.dev>
 * @version $Id$
 *
 * This program can be distributed under the terms of the Apache License v2.0.
 * See the file LICENSE for details.
 **/

package dev.unexist.showcase.todo.infrastructure.persistence;

import dev.unexist.showcase.todo.domain.todo.Todo;
import dev.unexist.showcase.todo.domain.todo.TodoRepository;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import io.quarkus.panache.common.Parameters;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Named;
import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
@Named("todo_panache")
public class PanacheTodoRepository implements TodoRepository, PanacheRepository<Todo> {

    @Override
    @Transactional(Transactional.TxType.MANDATORY)
    public boolean add(Todo todo) {
        this.persist(todo);

        return true;
    }

    @Override
    public boolean update(Todo todo) {
        this.persist(todo);

        return true;
    }

    @Override
    @Transactional(Transactional.TxType.MANDATORY)
    public boolean deleteById(int id) {
        this.deleteById(id);

        return true;
    }

    @Override
    public List<Todo> getAll() {
        return this.find("#" + Todo.FIND_ALL).list();
    }

    @Override
    public Optional<Todo> findById(int id) {
        return this.find("#" + Todo.FIND_BY_ID,
                Parameters.with("id", id)).firstResultOptional();
    }
}
