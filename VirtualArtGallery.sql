create database virtualart;

use virtualart;

create table artists (
    artistid int primary key,
    name varchar(255) not null,
    biography text,
    nationality varchar(100)
);

create table categories (
    categoryid int primary key,
    name varchar(100) not null
);

create table artworks (
    artworkid int primary key,
    title varchar(255) not null,
    artistid int,
    categoryid int,
    year int,
    description text,
    imageurl varchar(255),
    foreign key (artistid) references artists (artistid),
    foreign key (categoryid) references categories (categoryid)
);

create table exhibitions (
    exhibitionid int primary key,
    title varchar(255) not null,
    startdate date,
    enddate date,
    description text
);

create table exhibitionartworks (
    exhibitionid int,
    artworkid int,
    primary key (exhibitionid, artworkid),
    foreign key (exhibitionid) references exhibitions (exhibitionid),
    foreign key (artworkid) references artworks (artworkid)
);


--dml commands to insert data

insert into artists (artistid, name, biography, nationality) values
(1, 'pablo picasso', 'renowned spanish painter and sculptor.', 'spanish'),
(2, 'vincent van gogh', 'dutch post-impressionist painter.', 'dutch'),
(3, 'leonardo da vinci', 'italian polymath of the renaissance.', 'italian');

insert into categories (categoryid, name) values
(1, 'painting'),
(2, 'sculpture'),
(3, 'photography');

insert into artworks (artworkid, title, artistid, categoryid, year, description, imageurl) values
(1, 'starry night', 2, 1, 1889, 'a famous painting by vincent van gogh.', 'starry_night.jpg'),
(2, 'mona lisa', 3, 1, 1503, 'the iconic portrait by leonardo da vinci.', 'mona_lisa.jpg'),
(3, 'guernica', 1, 1, 1937, 'pablo picasso powerful anti-war mural.', 'guernica.jpg'),
(4, 'star', 2, 1, 1876, 'a famous painting by vincent van gogh.', 'star.jpg'),
(5, 'alright night', 2, 1, 1907, 'a famous painting by vincent van gogh.', 'alright_night.jpg'),
(6, 'st.', 3, 3, 1806, 'a famous painting ', 'hjk.jpg'),
(7, 'tar', 3, 2, 1986, 'a famous painting vinvi.', 'syj.jpg'),
(8, 'artwo', 3, 2, 1872, 'world famous', 'rty.jpg'),
(9, 'autr', 3, 2, 1900, 'no details', 'fgh.jpg');

insert into exhibitions (exhibitionid, title, startdate, enddate, description) values
(1, 'modern art masterpieces', '2023-01-01', '2023-03-01', 'a collection of modern art masterpieces.'),
(2, 'renaissance art', '2023-04-01', '2023-06-01', 'a showcase of renaissance art treasures.');

insert into exhibitionartworks (exhibitionid, artworkid) values
(1, 1),
(1, 2),
(1, 3),
(2, 2);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--1. retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
select a.name , count(*) as totalartwork from artists a join artworks aw on
a.artistid=aw.artistid group by a.name order by count(*);


--2. list the titles of artworks created by artists from 'spanish' and 'dutch' nationalities, and order them by the year in ascending order.
select aw.title, aw.year from artworks aw join artists a
on a.artistid= aw.artistid where a.nationality in ('Spanish','Dutch') order by aw.year;


--3. find the names of all artists who have artworks in the 'painting' category, and the number of artworks they have in this category.
select a.name , count(*) as totalartworkinpaint from artists a join artworks aw on
a.artistid=aw.artistid join categories c on aw.categoryid=c.categoryid
where c.name='Painting' group by a.name;


--4. list the names of artworks from the 'modern art masterpieces' exhibition, along with their artists and categories.
select aw.title , a.name, c.name as category from exhibitionartworks ea
join artworks aw on ea.artworkid = aw.artworkid join artists a on a.artistid = aw.artistid
join categories c on aw.categoryid = c.categoryid join exhibitions e on ea.exhibitionid = e.exhibitionid
where e.title = 'Modern Art Masterpieces';


--5. find the artists who have more than two artworks in the gallery.
select a.name , count(*) as totalartwork from artists a join artworks aw on
a.artistid=aw.artistid group by a.name having count(*)>2 order by count(*);


--6. find the titles of artworks that were exhibited in both 'modern art masterpieces' and 'renaissance art' exhibitions
select a.title as artwork, e.title as exhibition  from exhibitionartworks ea
join artworks a on ea.artworkid = a.artworkid join exhibitions e on ea.exhibitionid = e.exhibitionid
where e.title in ('Modern Art Masterpieces','Renaissance Art');


--7. find the total number of artworks in each category
select c.name, count(*) totalartworks from artworks aw join categories c
on aw.categoryid=c.categoryid group by c.name;


--8. list artists who have more than 3 artworks in the gallery.
select a.name , count(*) as totalartwork from artists a join artworks aw on
a.artistid=aw.artistid group by a.name having count(*)>3 order by count(*);


--9. find the artworks created by artists from a specific nationality (e.g., spanish).
select aw.title, a.nationality from artworks aw left join artists a
on a.artistid= aw.artistid where a.nationality ='Spanish';


--10. list exhibitions that feature artwork by both vincent van gogh and leonardo da vinci.
select e.title as exhibition  from artists a join artworks aw 
on aw.artistid=a.artistid join exhibitionartworks ea on ea.artworkid = aw.artworkid join exhibitions e on ea.exhibitionid = e.exhibitionid
where a.name in ('Leonardo Da Vinci','Vincent Van Gogh') group by e.title having count(distinct a.name)>1;


--11. find all the artworks that have not been included in any exhibition.
select aw.title from artworks aw where aw.artworkid not in (select artworkid from exhibitionartworks);


--12. list artists who have created artworks in all available categories.
select a.name from artists a join artworks aw on aw.artistid = a.artistid
join categories c on aw.categoryid = c.categoryid group by a.name
having count(distinct c.categoryid) = (select count(*) from categories);


--13. list the total number of artworks in each category.
select c.name, count(*) as totalartwork from artworks aw join categories c 
on aw.categoryid=c.categoryid group by c.name;


--14. find the artists who have more than 2 artworks in the gallery.
select a.name , count(*) as totalartwork from artists a join artworks aw on
a.artistid=aw.artistid group by a.name having count(*)>2 order by count(*);


--15. list the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
select c.name, avg(a.year) as averageyear from categories c 
join artworks a on c.categoryid = a.categoryid group by c.name having count(*) > 1;


--16. find the artworks that were exhibited in the 'modern art masterpieces' exhibition.
select a.title as artwork, aw.name as artist from exhibitionartworks ea
join artworks a on ea.artworkid = a.artworkid join artists aw on a.artistid = aw.artistid
join exhibitions e on ea.exhibitionid = e.exhibitionid where e.title = 'Modern Art Masterpieces';


--17. find the categories where the average year of artworks is greater than the average year of all artworks.
select c.name, avg(a.year) as averageyear from categories c 
join artworks a on c.categoryid = a.categoryid group by c.name 
having avg(a.year) > (select avg(year) from artworks);


--18. list the artworks that were not exhibited in any exhibition.
select aw.title from artworks aw where aw.artworkid not in (select artworkid from exhibitionartworks);


--19. show artists who have artworks in the same category as "mona lisa."
select a.name, aw.title, c.name from artists a join artworks aw on a.artistid=aw.artistid
join categories c on c.categoryid=aw.categoryid where 
aw.categoryid = (select categoryid from artworks where title = 'Mona Lisa');


--20. list the names of artists and the number of artworks they have in the gallery.
select a.name, count(*) as totalartworks from artists a join artworks aw on a.artistid=aw.artistid
group by a.name;
