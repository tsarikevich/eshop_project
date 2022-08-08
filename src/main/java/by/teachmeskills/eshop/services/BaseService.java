package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.BaseEntity;
import by.teachmeskills.eshop.exceptions.ImageException;

import java.util.List;

public interface BaseService<T extends BaseEntity> {
    T create(T entity);

    List<T> read();

    T update(T entity) throws ImageException;

    void delete(int id);
}
