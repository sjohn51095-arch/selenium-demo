package com.demo;

import java.net.MalformedURLException;
import java.net.URL;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.testng.annotations.Test;

public class testcase {

    @Test
    public void launch() throws MalformedURLException {
        System.out.println("Starting RemoteWebDriver...");

        String seleniumHost = System.getenv("SELENIUM_URL");
        if (seleniumHost == null || seleniumHost.isEmpty())
         seleniumHost = "http://74.225.21.195:4444/wd/hub";
        
        System.out.println("Connecting to Selenium Hub at: " + seleniumHost); 
        URL seleniumServerURL = new URL(seleniumHost);

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--remote-allow-origins=*");
        options.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage");

        WebDriver driver = null;
        try {
            driver = new RemoteWebDriver(seleniumServerURL, options);
            driver.get("https://www.google.com");
            System.out.println("Page title is: " + driver.getTitle());
        } finally {
            if (driver != null) driver.quit();
        }
    }
}
