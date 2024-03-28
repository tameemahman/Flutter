package com.sabit.crudflutter.controller;


import com.sabit.crudflutter.model.Product;
import com.sabit.crudflutter.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("api/products")
@CrossOrigin(origins = "*")

public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @GetMapping
    public ResponseEntity<List<Product>> getAllProduct(){
        List<Product> productList=productRepository.findAll();
        return ResponseEntity.ok(productList);
    }

    @PostMapping
    public ResponseEntity<Product> saveProduct(@RequestBody Product product){
        Product saveProduct = productRepository.save(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(saveProduct);

    }


    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        return product.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @RequestBody Product product){
        Optional<Product> existingProduct = productRepository.findById(id);
        if (existingProduct.isPresent()){
            product.setId(id);
            Product updateProduct =  productRepository.save(product);
            return ResponseEntity.ok(updateProduct);
        }else {
            return ResponseEntity.notFound().build();
        }

    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id){
        productRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
