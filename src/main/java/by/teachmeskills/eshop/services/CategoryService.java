package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.Category;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.Writer;

public interface CategoryService extends BaseService<Category> {
    ModelAndView getAllCategories();

    void writeCategoriesToCsv(Writer writer);

    void saveCategoriesFromCsv(MultipartFile file);
}
