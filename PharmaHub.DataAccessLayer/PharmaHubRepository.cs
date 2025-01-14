using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PharmaHub.DataAccessLayer.Models;
using PharmaHub.DataTranferObject;

namespace PharmaHub.DataAccessLayer
{
    public class PharmaHubRepository
    {
        PharmaHubDbContext _context;

        public PharmaHubRepository(PharmaHubDbContext context)
        {
            _context = context;
        }

        public User GetUser(string emailId, string password)
        {
            User user = new User();
            try
            {
                user = (from getUser in _context.Users
                        where getUser.EmailId == emailId && getUser.UserPassword == password
                        select getUser).FirstOrDefault();
                if(user != null)
                {
                    return user;
                }
                else
                {
                    return user;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<Product> GetProducts()
        {
            List<Product> products = new List<Product>();
            try
            {
                products = (from getProduct in _context.Products
                            select getProduct).ToList();    
                if(products != null)
                {
                    return products;
                }
                else
                {
                    return products;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<Product> GetProductsByCategory(int category)
        {
            List<Product> products = new List<Product>();
            try
            {
                products = (from getProduct in _context.Products
                            where getProduct.CategoryId == category
                            select getProduct).ToList();
                if (products != null)
                {
                    return products;
                }
                else
                {
                    return products;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<Category> GetCategories() 
        {
            List<Category> categories = new List<Category>();
            try
            {
                categories = (from getCategory in _context.Categories
                              select getCategory).ToList();
                if (categories != null)
                {
                    return categories;
                }
                else
                {
                    return categories;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public bool AddUser(UserDTO user)
        {
            bool status = false;
            try
            {
                User newUser = new User();
                newUser.EmailId = user.EmailId;
                newUser.UserPassword = user.UserPassword;
                newUser.RoleId = user.RoleId;
                newUser.Address = user.Address;
                newUser.DateOfBirth = user.DateOfBirth;
                _context.Users.Add(newUser);
                _context.SaveChanges();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public bool AddProduct(ProductDTO product)
        {
            bool status = false;

            try
            {
                //Product newProduct = new Product();
                //newProduct.ProductName = product.ProductName;
                //newProduct.CategoryId = product.CategoryId;
                //newProduct.Price = product.Price;
                //newProduct.Quantity = product.Quantity;
                //newProduct.Description = product.Description;
                //_context.Products.Add(newProduct);
                //_context.SaveChanges();
                //return true;
            }
            catch (Exception)
            {
                return false;
            }
            return status;
        }

        public bool UpdateProduct(ProductDTO product)
        {
            bool status = false;
            try
            {
                //Product updateProduct = (from getProduct in _context.Products
                //                         where getProduct.ProductId == product.ProductId
                //                         select getProduct).FirstOrDefault();
                //updateProduct.ProductName = product.ProductName;
                //updateProduct.CategoryId = product.CategoryId;
                //updateProduct.Price = product.Price;
                //updateProduct.Quantity = product.Quantity;
                //updateProduct.Description = product.Description;
                //_context.SaveChanges();
                //return true;
            }
            catch (Exception)
            {
                return false;
            }
            return status;
        }


    }
}
