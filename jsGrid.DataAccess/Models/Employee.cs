﻿using System;

namespace JsDataGrids.DataAccess.Models
{
    public class Employee
    {
        public Guid Id { get; set; }
        public string Salutation { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public string DateOfBirth { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string AddressLine { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string State { get; set; }
        public decimal Salary { get; set; }
        public string SSN { get; set; }
    }
}