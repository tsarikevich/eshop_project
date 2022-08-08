package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.dto.SearchParamsDto;
import by.teachmeskills.eshop.entities.Product;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.Writer;

public interface ProductService extends BaseService<Product> {
    ModelAndView showSearchProductPage();

    ModelAndView getProductData(int id);

    ModelAndView getCategoryProductsData(int id, String nameCategory, int pageNumber, int pageSize);

    ModelAndView searchProducts(SearchParamsDto searchParamsDto, int pageNumber, int pageSize);

    void writeProductsCategoryToCsv(int categoryId, Writer writer);

    void saveProductsCategoryFromCsv(int id, MultipartFile file);
}
