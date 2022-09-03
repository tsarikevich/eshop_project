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

import static by.teachmeskills.eshop.utils.EshopConstants.FILE;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_NUMBER;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_SIZE;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_HOME_PAGE;

@RestController
@RequestMapping("/home")
public class HomeController {
    private final CategoryService categoryService;

    public HomeController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public ModelAndView getHomePage(@RequestParam(value = PAGE_NUMBER, defaultValue = "0") int pageNumber,
                                    @RequestParam(value = PAGE_SIZE, defaultValue = "6") int pageSize){
        return categoryService.getAllCategories(pageNumber, pageSize);
    }

    @GetMapping("/download")
    public void downloadCsvFile(HttpServletResponse response) {
        categoryService.writeCategoriesToCsv(response);
    }

    @PostMapping("/upload")
    public ModelAndView uploadCategoriesFromFile(@RequestParam(FILE) MultipartFile file) {
        categoryService.saveCategoriesFromCsv(file);
        return new ModelAndView(REDIRECT_TO_HOME_PAGE);
    }
}
