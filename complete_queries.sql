--N/A Get all artists
select a.artist_id, a.artist_name, count(amd.md_id) as count
from mediaserver.artist a left outer join mediaserver.artistmetadata amd on (a.artist_id=amd.artist_id)
group by a.artist_id, a.artist_name
order by a.artist_name;

--N/A Get all songs
select s.song_id, s.song_title, string_agg(saa.artist_name,',') as artists
from mediaserver.song s left outer join 
            (mediaserver.Song_Artists sa join
			 	mediaserver.Artist a on (sa.performing_artist_id=a.artist_id))
				as saa  on (s.song_id=saa.song_id)
group by s.song_id, s.song_title
order by s.song_id

--N/A Get all podcasts
select p.*, pnew.count as count  
from mediaserver.podcast p, 
                (select p1.podcast_id, count(*) as count 
                 from mediaserver.podcast p1 left outer join
				 	mediaserver.podcastepisode pe1 on (p1.podcast_id=pe1.podcast_id) 
                 group by p1.podcast_id) pnew 
where p.podcast_id = pnew.podcast_id;

--N/A Get all movies
select m.movie_id, m.movie_title, m.release_year, count(mimd.md_id) as count
from mediaserver.movie m left outer join mediaserver.mediaitemmetadata mimd on (m.movie_id = mimd.media_id)
group by m.movie_id, m.movie_title, m.release_year
order by movie_id;

--N/A Get all albums
select a.album_id, a.album_title, anew.count as count, anew.artists
	from mediaserver.album a, (select a1.album_id, count(distinct as1.song_id) as count, array_to_string(array_agg(distinct ar1.artist_name),',') as artists
                               from mediaserver.album a1 
								left outer join mediaserver.album_songs as1 on (a1.album_id=as1.album_id) 
								left outer join mediaserver.song s1 on (as1.song_id=s1.song_id)
								left outer join mediaserver.Song_Artists sa1 on (s1.song_id=sa1.song_id)
								left outer join mediaserver.artist ar1 on (sa1.performing_artist_id=ar1.artist_id)
                                group by a1.album_id) anew 
                                where a.album_id = anew.album_id;

--N/A Get one artist
select *
from mediaserver.artist a left outer join 
	(mediaserver.artistmetadata natural join mediaserver.metadata natural join mediaserver.MetaDataType) amd
        on (a.artist_id=amd.artist_id)
where a.artist_id=3

--N/A Get one movie
select * from mediaserver.movie m left outer join 
	(mediaserver.mediaitemmetadata natural join mediaserver.metadata natural join mediaserver.MetaDataType) mmd
        on (m.movie_id=mmd.media_id)
where m.movie_id=1024;

--N/A Find all matching tvshows
select t.*, tnew.count as count  
from mediaserver.tvshow t, (select t1.tvshow_id, count(te1.media_id) as count 
                            from mediaserver.tvshow t1 left outer join
								mediaserver.TVEpisode te1 on (t1.tvshow_id=te1.tvshow_id) 
                            group by t1.tvshow_id) tnew 
where t.tvshow_id = tnew.tvshow_id and lower(tvshow_title) ~ lower('Thr')
order by t.tvshow_id;

--Q1a User subscribed Podcasts
SELECT	PD.podcast_id, PD.podcast_title, PD.podcast_uri, PD.podcast_last_updated
FROM	mediaserver.subscribed_podcasts SP NATURAL JOIN mediaserver.podcast PD
WHERE	SP.username = 'charles.smith'
ORDER BY PD.podcast_id;

--Q1b User Playlists
SELECT	MC.collection_id, MC.collection_name, count(MC.collection_id)
FROM	mediaserver.mediacollection MC NATURAL JOIN mediaserver.mediacollectioncontents MCC
WHERE	MC.username = 'charles.smith'
GROUP BY MC.collection_id, MC.collection_name
ORDER BY MC.collection_id;

--Q1c User current in-progress items
SELECT	MC.media_id, MC.play_count, MC.progress, MC.lastviewed, MI.storage_location
FROM	mediaserver.usermediaconsumption MC NATURAL JOIN mediaserver.mediaitem MI
WHERE	MC.username = 'charles.smith' AND
		MC.progress != 100.00
ORDER BY MC.media_id;

--Don't think this is right..
--Q2abc Get a song by their ID in your media server
SELECT	S.song_title, S.length, ART.artist_name
FROM	mediaserver.song S NATURAL JOIN mediaserver.song_artists SA NATURAL JOIN mediaserver.artist ART
WHERE	S.song_id = 3769;

--Q2d Get the meta for a song by their ID in your media server
SELECT	S.song_title, md_type_name, md_value
FROM 	(mediaserver.mediaitemmetadata MI JOIN mediaserver.song S ON (MI.media_id = S.song_id))
		NATURAL JOIN mediaserver.metadatatype NATURAL JOIN mediaserver.metadata
WHERE	S.song_id = 3769;

--Q3a,b,c Get all the TV Shows in your media server
SELECT	tvshow_id, tvshow_title, count(tvshow_id)
FROM	mediaserver.tvshow NATURAL JOIN mediaserver.tvepisode
GROUP BY tvshow_id, tvshow_title
ORDER BY tvshow_id;

--Q4a,b Get one tvshow in your media server
SELECT	tvshow_title, md_type_name, md_value
FROM	(mediaserver.tvshow NATURAL JOIN mediaserver.tvshowmetadata) 
		NATURAL JOIN mediaserver.metadatatype NATURAL JOIN mediaserver.metadata
WHERE	tvshow_id = 1;

--Q4c Get all tvshow episodes for one tv show in your media server
SELECT	media_id, tvshow_episode_title, season, episode, air_date
FROM	mediaserver.tvepisode
WHERE	tvshow_id = 1;

--Still to do.
--Q5a,b Get one album
--Q5c Get all genres for one album
--Q5d Get all songs for one album
--Q6a,b,c,d,e Get a podcast by their ID in your media server
--Q6f Get all podcast eps for one podcast by their podcast ID in your media server
--Q7a,b,c,d,e,f Get a podcast ep by their ID in your media server
--Q8 Add a new Song

--Q9 Find all matching Movies
SELECT m.*
FROM mediaserver.movie m 
WHERE movie_title ~* %s
ORDER BY m.movie_id;

--Q10 - Get all songs for one song_genre

SELECT DISTINCT MT.md_type_name
FROM mediaserver.metadata MD NATURAL JOIN mediaserver.metadatatype MT
WHERE MD.md_value = 'rock';


SELECT s.song_id as item_id, s.song_title as item_title, 'song' as media_type
FROM (mediaserver.song s JOIN mediaserver.mediaitemmetadata mi on (s.song_id = mi.media_id))
	NATURAL JOIN mediaserver.metadatatype
	NATURAL JOIN mediaserver.metadata MD
WHERE MD.md_value ='rock'
ORDER BY s.song_id;

--Q10 - Get all podcasts for one podcast_genre
--Q10 - Get all movies and tv shows for one film_genre

