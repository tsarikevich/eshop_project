package by.teachmeskills.eshop.controllers;
import by.teachmeskills.eshop.services.CategoryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import static by.teachmeskills.eshop.utils.EshopConstants.FILE;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_HOME;

@RestController
@RequestMapping("/home")
public class HomeController {
    private final CategoryService categoryService;

    public HomeController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public ModelAndView getHomePage() {
        return categoryService.getAllCategories();
    }

    @GetMapping("/download")
    public void downloadCsvFile(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF8");
        response.addHeader("Content-Disposition", "attachment; filename=categories.csv");
        categoryService.writeCategoriesToCsv(response.getWriter());
    }

    @PostMapping("/upload")
    public ModelAndView uploadCategoriesFromFile(@RequestParam(FILE) MultipartFile file) {
        categoryService.saveCategoriesFromCsv(file);
        return new ModelAndView(REDIRECT_TO_HOME);
    }
}
