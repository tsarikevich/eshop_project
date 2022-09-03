package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.dto.SearchParamsDto;
import by.teachmeskills.eshop.entities.BaseEntity;
import by.teachmeskills.eshop.entities.Category;
import by.teachmeskills.eshop.entities.Product;
import by.teachmeskills.eshop.repositories.CategoryRepository;
import by.teachmeskills.eshop.repositories.ProductRepository;
import by.teachmeskills.eshop.repositories.ProductSearchSpecification;
import by.teachmeskills.eshop.services.ProductService;
import by.teachmeskills.eshop.services.UserService;
import com.opencsv.CSVWriter;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import lombok.extern.log4j.Log4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static by.teachmeskills.eshop.utils.EshopConstants.CATEGORY_ID;
import static by.teachmeskills.eshop.utils.EshopConstants.CHECK_FIRST_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.CHECK_LAST_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.LOGIN_AUTH_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.NAME_CATEGORY;
import static by.teachmeskills.eshop.utils.EshopConstants.ONE_PRODUCT;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_NUMBER;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_SIZE;
import static by.teachmeskills.eshop.utils.EshopConstants.PRODUCTS;
import static by.teachmeskills.eshop.utils.EshopConstants.PRODUCTS_FROM_SEARCH;
import static by.teachmeskills.eshop.utils.EshopConstants.SEARCH_PARAMS;
import static by.teachmeskills.eshop.utils.EshopConstants.TOTAL_ELEMENTS;
import static by.teachmeskills.eshop.utils.EshopConstants.TOTAL_PAGES;
import static by.teachmeskills.eshop.utils.PagesPathEnum.CATEGORY_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.PRODUCT_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.SEARCH_PAGE;

@Service
@Log4j
public class ProductServiceImpl implements ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final UserService userService;

    public ProductServiceImpl(ProductRepository productRepository, CategoryRepository categoryRepository, UserService userService) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.userService = userService;
    }

    @Override
    public Product create(Product entity) {
        return productRepository.saveAndFlush(entity);
    }

    @Override
    public List<Product> read() {
        return productRepository.findAll();
    }

    @Override
    public Product update(Product entity) {
        Optional<Product> product = productRepository.findById(entity.getId());
        if (product.isPresent()) {
            entity.setImages(product.get().getImages());
            return productRepository.save(entity);
        } else {
            log.error("Product doesn't exist");
            return null;
        }
    }

    @Override
    public void delete(int id) {
        productRepository.deleteById(id);
    }

    @Override
    public ModelAndView showSearchProductPage() {
        ModelMap modelMap = new ModelMap();
        modelMap.addAttribute(LOGIN_AUTH_USER, userService.getAuthorizationUserLoginOrDefault());
        return new ModelAndView(SEARCH_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView getProductData(int id) {
        ModelMap modelMap = new ModelMap();
        Optional<Product> product = productRepository.findById(id);
        modelMap.addAttribute(LOGIN_AUTH_USER, userService.getAuthorizationUserLoginOrDefault());
        if (product.isPresent()) {
            modelMap.addAttribute(ONE_PRODUCT, product.get());
        } else {
            log.error("Product wasn't found for product page");
        }
        return new ModelAndView(PRODUCT_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView getCategoryProductsData(int id, String nameCategory, int pageNumber, int pageSize) {
        ModelMap modelMap = new ModelMap();
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("name", "description"));
        Page<Product> page = productRepository.findAllByCategoryId(id, paging);
        modelMap.addAttribute(NAME_CATEGORY, nameCategory);
        modelMap.addAttribute(CATEGORY_ID, id);
        modelMap.addAttribute(PRODUCTS, page.getContent());
        addAttributeToModelMap(page, pageNumber, pageSize, modelMap);
        return new ModelAndView(CATEGORY_PAGE.getPath(), modelMap);
    }


    @Override
    public ModelAndView searchProducts(SearchParamsDto searchParamsDto, int pageNumber, int pageSize) {
        ModelMap modelMap = new ModelMap();
        ProductSearchSpecification productSearchSpecification = new ProductSearchSpecification(searchParamsDto);
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("name", "description"));
        Page<Product> page = productRepository.findAll(productSearchSpecification, paging);
        modelMap.addAttribute(SEARCH_PARAMS, searchParamsDto);
        modelMap.addAttribute(PRODUCTS_FROM_SEARCH, page.getContent());
        addAttributeToModelMap(page, pageNumber, pageSize, modelMap);
        return new ModelAndView(SEARCH_PAGE.getPath(), modelMap);
    }

    protected void addAttributeToModelMap(Page<? extends BaseEntity> page, int pageNumber, int pageSize, ModelMap modelMap) {
        modelMap.addAttribute(PAGE_NUMBER, pageNumber);
        modelMap.addAttribute(PAGE_SIZE, pageSize);
        modelMap.addAttribute(TOTAL_ELEMENTS, page.getTotalElements());
        modelMap.addAttribute(TOTAL_PAGES, page.getTotalPages());
        modelMap.addAttribute(CHECK_FIRST_PAGE, page.isFirst());
        modelMap.addAttribute(CHECK_LAST_PAGE, page.isLast());
        modelMap.addAttribute(LOGIN_AUTH_USER, userService.getAuthorizationUserLoginOrDefault());
    }

    @Override
    public void writeProductsCategoryToCsv(int categoryId, HttpServletResponse response) {
        try {
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF8");
            response.addHeader("Content-Disposition", "attachment; filename=productsCategory.csv");
            List<Product> products = productRepository.getProductsByCategoryId(categoryId);
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(response.getWriter())
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(products);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException | IOException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void saveProductsCategoryFromCsv(int id, MultipartFile file) {
        try {
            Optional<Category> category = categoryRepository.findById(id);
            List<Product> csvProducts = parseCsv(file);
            if (Optional.ofNullable(csvProducts).isPresent() && csvProducts.size() > 0) {
                for (Product csvProduct : csvProducts) {
                    csvProduct.setCategory(category.get());
                }
                productRepository.saveAll(csvProducts);
            } else {
                throw new FileNotFoundException("A file wasn't found for upload new products");
            }
        } catch (Exception e) {
            log.error(e.getMessage());
        }
    }


    private List<Product> parseCsv(MultipartFile file) {
        if (Optional.ofNullable(file).isPresent()) {
            try (Reader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
                CsvToBean<Product> csvToBean = new CsvToBeanBuilder(reader)
                        .withType(Product.class)
                        .withIgnoreLeadingWhiteSpace(true)
                        .withSeparator(',')
                        .build();
                return csvToBean.parse();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            log.error("Empty CSV file is uploaded.");
        }
        return Collections.emptyList();
    }
}
