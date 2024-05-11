SELECT * FROM world_layoffs.layoffs_staging2;

Insert into layoffs_staging2
select *,
row_number() over(partition by company, location, industry, total_laid_off, 
				percentage_laid_off,`date`, stage, country, funds_raised_millions) as Row_numb
from layoffs_staging;

delete 
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num = 1;

-- standardizing data

select company, trim(company)
from layoffs_staging2; 

update layoffs_staging2
set company = trim(company);

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging2;

select distinct country
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country);

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null or industry = '';

select *
from layoffs_staging2
where company = 'airbnb';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry = '') and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '') and t2.industry is not null;

delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;










