package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.Category;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;

public interface CategoryService extends BaseService<Category> {
    ModelAndView getAllCategories(int pageNumber,int pageSie);

    void writeCategoriesToCsv(HttpServletResponse response);

    void saveCategoriesFromCsv(MultipartFile file);
}
