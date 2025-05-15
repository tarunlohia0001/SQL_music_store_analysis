-- Q1.who is the senior most employee of the company??
--code
--select *from employee
--order by levels desc
--limit 1


--Q2.which country has the most invoices??
--code
--select count(*), billing_country
--from invoice
--group by billing_country
--order by billing_country desc


--Q3.what are the top 3 total values of invoices?
--code
--select*from invoice
--order by total desc
--limit 3


--Q4.which country has the best customers?
--code
--SELECT SUM(total) AS invoice_total, billing_state
--FROM invoice
--GROUP BY billing_state
--ORDER BY invoice_total DESC


--Q5.who is the best customer??
--code
--select customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) as total
--from customer
--join invoice on customer.customer_id=invoice.customer_id
--group by customer.customer_id
--order by total desc
--limit 1


------------moderate level questions--------------

--Q6.write query to return the email,first_name,last_name &genre 
--of all rock music listeners.return your list ordered alphabetical by email starting with A.
--code
--SELECT DISTINCT customer.email, customer.first_name, customer.last_name
--FROM customer
--JOIN invoice ON customer.customer_id = invoice.customer_id
--JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
--WHERE invoice_line.track_id IN (
    --SELECT track.track_id
    --FROM track
    --JOIN genre ON track.genre_id = genre.genre_id
    --WHERE LOWER(genre.name) = 'rock'
--)
--ORDER BY customer.email;


--Q7.let's invite the artist who have written the rck most in our datasheet.
--write a query that return the artist name and total count of the top 10 rock brands?
--code
--SELECT artist.artist_id,artist.name,COUNT(artist.artist_id)AS number_of_songs
--FROM track
--JOIN album ON album.album_id=track.album_id
--JOIN artist ON artist.artist_id=album.artist_id
--JOIN genre ON genre.genre_id=track.genre_id
--WHERE genre.name LIKE 'Rock'
--GROUP BY artist.artist_id
--ORDER BY number_of_songs DESC
--LIMIT 10

--Q8.REturn all the track names that have a strong length longer than than the average song length.
--written the names and millisec for each track ordered by the song length with the longest song listed first.
--code
--SELECT name,milliseconds
--from track
--WHERE milliseconds >(
--SELECT AVG(milliseconds) AS avg_track_length
	--from track)
--ORDER BY milliseconds DESC

--Alternate 

--SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
--FROM customer
--JOIN invoice ON invoice.customer_id=customer.customer_id
--JOIN invoice_line ON invoice_line.invoice_id=invoice.invoice_id
--JOIN track ON track.track_id=invoice_line.track_id
--JOIN genre ON genre.genre_id=track.genre_id
--WHERE genre.name LIKE 'Rock'
--ORDER BY email


----------------ADVANCED LEVEL QUESTION------------------ 

--Q1.Find how much amount is spend by each customer on artist?write a query to customer name ,artist name and total spend ..
--code
WITH best_selling_artist AS (
    SELECT 
        artist.artist_id AS artist_id, 
        artist.name AS artist_name, 
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY artist.artist_id, artist.name
    ORDER BY total_sales DESC
    LIMIT 1
)

SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name, 
    SUM(il.unit_price * il.quantity) AS amount_spend
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spend DESC;

