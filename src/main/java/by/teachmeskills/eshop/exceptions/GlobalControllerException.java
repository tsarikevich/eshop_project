package by.teachmeskills.eshop.exceptions;

import lombok.extern.log4j.Log4j;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import static by.teachmeskills.eshop.utils.EshopConstants.DESCRIPTION_ERROR_MESSAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.ERROR_PAGE;

@ControllerAdvice(basePackages = "by.teachmeskills.eshop.controllers")
@Log4j
public class GlobalControllerException {

    @ExceptionHandler
    public ModelAndView globalException(Exception e) {
        log.error(e.getMessage());
        ModelMap modelMap = new ModelMap();
        modelMap.addAttribute(DESCRIPTION_ERROR_MESSAGE, e.getMessage());
        return new ModelAndView(ERROR_PAGE.getPath(), modelMap);
    }
}
