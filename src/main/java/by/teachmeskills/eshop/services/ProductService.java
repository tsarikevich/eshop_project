package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.dto.SearchParamsDto;
import by.teachmeskills.eshop.entities.Product;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;

public interface ProductService extends BaseService<Product> {
    ModelAndView showSearchProductPage();

    ModelAndView getProductData(int id);

    ModelAndView getCategoryProductsData(int id, String nameCategory, int pageNumber, int pageSize);

    ModelAndView searchProducts(SearchParamsDto searchParamsDto, int pageNumber, int pageSize);

    void writeProductsCategoryToCsv(int categoryId, HttpServletResponse response);

    void saveProductsCategoryFromCsv(int id, MultipartFile file);
}
