import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class CheckPageTitle {
    public static void main(String[] args) {
        // Set the path to your ChromeDriver
        //System.setProperty("webdriver.chrome.driver", "C:\\path\\to\\chromedriver\\chromedriver.exe");

        // Initialize the WebDriver
        WebDriver driver = new ChromeDriver();

        // Open the webpage (replace 'your_url' with the actual URL of your webpage)
        driver.get("https://www.sec.gov/ix?doc=/Archives/edgar/data/821189/000082118924000021/eog-20240331.htm");  // Replace with your actual URL

        try {
            // Get and print the page title
            String pageTitle = driver.getTitle();
            System.out.println("Page Title: " + pageTitle);
        } catch (Exception e) {
            System.out.println("Error occurred while retrieving the page title.");
            e.printStackTrace();
        } finally {
            // Close the WebDriver
            driver.quit();
        }
    }
}
