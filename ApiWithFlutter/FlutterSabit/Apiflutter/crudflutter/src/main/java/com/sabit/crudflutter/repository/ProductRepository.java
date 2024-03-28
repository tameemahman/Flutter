package com.sabit.crudflutter.repository;

import com.sabit.crudflutter.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {

}
