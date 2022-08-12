package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.dto.SearchParamsDto;
import by.teachmeskills.eshop.entities.Category;
import by.teachmeskills.eshop.entities.Image;
import by.teachmeskills.eshop.entities.Product;
import by.teachmeskills.eshop.repositories.CategoryRepository;
import by.teachmeskills.eshop.repositories.ImageRepository;
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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static by.teachmeskills.eshop.utils.EshopConstants.CATEGORY_ID;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_NUMBER;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_SIZE;
import static by.teachmeskills.eshop.utils.EshopConstants.TOTAL_PAGES;
import static by.teachmeskills.eshop.utils.PagesPathEnum.CATEGORY_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.PRODUCT_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.SEARCH_PAGE;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ACTIVE_BUTTON_NAV_MENU;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CHECK_FIRST_PAGE;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CHECK_LAST_PAGE;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.IMAGES_FROM_SEARCH;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.NAME_CATEGORY;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ONE_PRODUCT;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ONE_PRODUCT_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.PRODUCTS;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.PRODUCTS_FROM_SEARCH;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.PRODUCTS_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.SEARCH_PARAMS;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.USER;

@Service
@Log4j
public class ProductServiceImpl implements ProductService {
    private final ProductRepository productRepository;
    private final ImageRepository imageRepository;
    private final CategoryRepository categoryRepository;
    private final UserService userService;

    public ProductServiceImpl(ProductRepository productRepository, ImageRepository imageRepository, CategoryRepository categoryRepository, UserService userService) {
        this.productRepository = productRepository;
        this.imageRepository = imageRepository;
        this.categoryRepository = categoryRepository;
        this.userService = userService;
    }

    @Override
    public Product create(Product entity) {
        return productRepository.save(entity);
    }

    @Override
    public List<Product> read() {
        return productRepository.findAll();
    }

    @Override
    public Product update(Product entity) {
        Product product = productRepository.getProductById(entity.getId());
        return productRepository.save(product);
    }

    @Override
    public void delete(int id) {
        productRepository.deleteById(id);
    }

    @Override
    public ModelAndView showSearchProductPage() {
        ModelMap modelMap = new ModelMap();
        modelMap.addAttribute(USER.getValue(), userService.getAuthorizationUserOrNull());
        modelMap.addAttribute(ACTIVE_BUTTON_NAV_MENU.getValue(), true);
        return new ModelAndView(SEARCH_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView getProductData(int id) {
        ModelMap modelMap = new ModelMap();
        Product product = productRepository.getProductById(id);
        List<Image> productImages = imageRepository.getImagesByProductId(id);
        modelMap.addAttribute(ONE_PRODUCT.getValue(), product);
        modelMap.addAttribute(ONE_PRODUCT_IMAGES.getValue(), productImages);
        return new ModelAndView(PRODUCT_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView getCategoryProductsData(int id, String nameCategory, int pageNumber, int pageSize) {
        ModelMap modelMap = new ModelMap();
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("name"));
        Page<Product> pageProducts = productRepository.findAllByCategoryId(id, paging);
        List<Image> productsImages = imageRepository.getImagesByCategoryId(id);
        modelMap.addAttribute(PRODUCTS.getValue(), pageProducts.getContent());
        modelMap.addAttribute(PRODUCTS_IMAGES.getValue(), productsImages);
        modelMap.addAttribute(NAME_CATEGORY.getValue(), nameCategory);
        modelMap.addAttribute(CATEGORY_ID, id);
        modelMap.addAttribute(PAGE_NUMBER, pageNumber);
        modelMap.addAttribute(PAGE_SIZE, pageSize);
        modelMap.addAttribute(TOTAL_PAGES, pageProducts.getTotalPages());
        modelMap.addAttribute(CHECK_FIRST_PAGE.getValue(), pageProducts.isFirst());
        modelMap.addAttribute(CHECK_LAST_PAGE.getValue(), pageProducts.isLast());
        return new ModelAndView(CATEGORY_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView searchProducts(SearchParamsDto searchParamsDto, int pageNumber, int pageSize) {
        ModelMap modelMap = new ModelMap();
        ProductSearchSpecification productSearchSpecification = new ProductSearchSpecification(searchParamsDto);
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("name"));
        Page<Product> productsPage = productRepository.findAll(productSearchSpecification, paging);
        List<Image> images = imageRepository.getImagesByProductIn(productsPage.getContent());
        modelMap.addAttribute(USER.getValue(), userService.getAuthorizationUserOrNull());
        modelMap.addAttribute(IMAGES_FROM_SEARCH.getValue(), images);
        modelMap.addAttribute(PRODUCTS_FROM_SEARCH.getValue(), productsPage.getContent());
        modelMap.addAttribute(PAGE_NUMBER, pageNumber);
        modelMap.addAttribute(PAGE_SIZE, pageSize);
        modelMap.addAttribute(TOTAL_PAGES, productsPage.getTotalPages());
        modelMap.addAttribute(CHECK_FIRST_PAGE.getValue(), productsPage.isFirst());
        modelMap.addAttribute(CHECK_LAST_PAGE.getValue(), productsPage.isLast());
        modelMap.addAttribute(ACTIVE_BUTTON_NAV_MENU.getValue(), true);
        modelMap.addAttribute(SEARCH_PARAMS.getValue(), searchParamsDto);
        return new ModelAndView(SEARCH_PAGE.getPath(), modelMap);
    }

    @Override
    public void writeProductsCategoryToCsv(int categoryId, Writer writer) {
        try {
            List<Product> products = productRepository.getProductByCategoryId(categoryId);
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(writer)
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(products);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void saveProductsCategoryFromCsv(int id, MultipartFile file) {
        Category category = categoryRepository.findCategoryById(id);
        List<Product> csvProducts = parseCsv(file);
        for (Product csvProduct : csvProducts) {
            csvProduct.setCategory(category);
        }
        if (Optional.of(csvProducts).isPresent() && csvProducts.size() > 0) {
            try {
                productRepository.saveAll(csvProducts);
            } catch (Exception e) {
                log.error(e.getMessage());
            }
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
