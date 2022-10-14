//
//  APICaller.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import Foundation

enum HTTPMethod: String {
	case GET
	case POST
	case DELETE
	case PUT
}

final class APICaller {

	static let shared = APICaller()

	struct Constants {
		// - Browse ----
		static let basicAPIURL       = "https://api.spotify.com/v1"
		static let newReleases       = "/browse/new-releases?limit=50"
		static let featuredPlaylists = "/browse/featured-playlists?limit=20"
		static let recommendations   = "/recommendations?limit=40"
		static let availableGenres   = "/recommendations/available-genre-seeds"

		// - Categories
		static let categories = "/browse/categories"

		// - Library
		static let mePlaylists = "/me/playlists"
	}

	enum APIError: Error {
		case failedToGetData
	}

	//MARK: - Browse
	public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + "/me"), type: .GET) { (baseRequest) in

			let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					/// Debug:
					/// let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					/// print(result)
					let result = try JSONDecoder().decode(UserProfile.self, from: data)
					completion(.success(result))

				} catch {
					completion(.failure(error))
				}

			}

			task.resume()
		}

	}

	public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {

		let url = URL(string: Constants.basicAPIURL + Constants.newReleases)

		createRequest(with: url, type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in
				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					/// Debug:
					/// let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					/// print(json)
					let newReleases = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
					completion(.success(newReleases))

				} catch {

				}
			}

			task.resume()
		}
	}

	public func getFeaturedPlaylist(completion: @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void) {
		let url = URL(string: Constants.basicAPIURL + Constants.featuredPlaylists)

		createRequest(with: url, type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in
				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					/// Debug:
					/// let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					/// print(json)
					let feaPlaylist = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
					completion(.success(feaPlaylist))

				} catch {
					print("Error decode featured playlists")
				}
			}

			task.resume()
		}
	}

	public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {

		let seeds = genres.joined(separator: ",")
		let url = URL(string: Constants.basicAPIURL + Constants.recommendations + "&seed_genres=\(seeds)")

		createRequest(with: url, type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let recommendations = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
					completion(.success(recommendations))

				} catch {
					print("Error decode Recommendations")
					completion(.failure(error))
				}
			}

			task.resume()
		}
	}

	public func getRecommendedGenres(completion: @escaping (Result<RecomendedGenresResponse, Error>) -> Void) {

		let url = URL(string: Constants.basicAPIURL + Constants.availableGenres)

		createRequest(with: url, type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let genres = try JSONDecoder().decode(RecomendedGenresResponse.self, from: data)
					completion(.success(genres))

				} catch {
					print("Failed to getRecommendedGenres!")
					completion(.failure(error))
				}
			}

			task.resume()
		}
	}

	//MARK: - ALbums

	public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
		createRequest(with: URL(string: Constants.basicAPIURL + "/me/albums?ids=\(album.id)"), type: .PUT) { (baseRequest) in

			var request = baseRequest
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			let task = URLSession.shared.dataTask(with: request) { data, response, error in

				guard let code = (response as? HTTPURLResponse)?.statusCode,
					  error == nil else {
					completion(false)
					return
				}

				//print(code)
				completion(code == 200)
			}

			task.resume()
		}
	}

	public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + "/me/albums"), type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//print(json)
					let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
					completion(.success(result.items.compactMap{ $0.album}))

				} catch {
					print("Error to get users albums! - \(error.localizedDescription)")
					completion(.failure(error))
				}
			}

			task.resume()
		}
	}

	public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
		let url = URL(string: Constants.basicAPIURL + "/albums/" + album.id)

		createRequest(with: url, type: .GET) { (request) in
			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let albumDetails = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
					completion(.success(albumDetails))

				} catch {
					print("Error to get album details! - \(error.localizedDescription)")
				}
			}

			task.resume()
		}
	}


	//MARK: - Playlists

	public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
		let url = URL(string: Constants.basicAPIURL + "/playlists/" + playlist.id)

		createRequest(with: url, type: .GET) { (request) in
			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let playlistDetails = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
					completion(.success(playlistDetails))

				} catch {
					print("Error to get playlist details!")
					completion(.failure(error))
				}
			}

			task.resume()
		}
	}

	public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + Constants.mePlaylists + "?limit=50"), type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
					completion(.success(result.items))

				} catch {

					print(error.localizedDescription)
					completion(.failure(error))
				}
			}

			task.resume()
		}
	}

	public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {

		getCurrentUserProfile { [weak self] (result) in
			switch result {
			case .success(let profile):
				let urlString = Constants.basicAPIURL + "/users/\(profile.id)/playlists"

				self?.createRequest(with: URL(string: urlString), type: .POST, completion: { (baseRequest) in

					var request = baseRequest
					let json = [ "name" : name]
					request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)


					let task = URLSession.shared.dataTask(with: request) { data, _, error in

						guard let data = data, error == nil else {
							completion(false)
							return
						}


						do {
							let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
							//print(json)

							if let response = json as? [String: Any], response["id"] as? String != nil  {
								completion(true)

							} else {
								completion(false)
							}



						}
						catch {
							print(error.localizedDescription)
							completion(false)
						}
					}

					task.resume()
				})

			case .failure(let error):
				print(error.localizedDescription)
				break
			}
		}


	}

	public func addTrackToPlaylist(track: AudioTrack,
								   playlist: Playlist,
								   completion: @escaping (Bool) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { (baseRequest) in

			var request = baseRequest
			let json = ["uris" : ["spotify:track:\(track.id)"]]
			request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(false)
					return
				}


				do {
					let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//print(result)
					if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
						completion(true)

					} else {
						completion(false)
					}

				}
				catch {
					print(error.localizedDescription)
					completion(false)

				}

			}

			task.resume()
		}
	}

	public func removeTrackFromPlaylist(track: AudioTrack,
										playlist: Playlist,
										completion: @escaping (Bool) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { (baseRequest) in

			var request = baseRequest
			let json = [
				"tracks" : [
					[ "uri" : "spotify:track:\(track.id)"]
				]
			]

			request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(false)
					return
				}


				do {
					let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//print(result)
					if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
						completion(true)

					} else {
						completion(false)
					}

				}
				catch {
					print(error.localizedDescription)
					completion(false)

				}

			}

			task.resume()
		}

	}

	//MARK: - Categories
	public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + Constants.categories + "?limit=50"), type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in
				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let result = try JSONDecoder().decode(AllCategoriesResponse.self,from: data)
					completion(.success(result.categories.items))

				} catch {
					completion(.failure(error))
					print("Error to load Categories! \(error.localizedDescription)")
				}
			}

			task.resume()
		}
	}

	public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {

		createRequest(with: URL(string: Constants.basicAPIURL + Constants.categories + "/\(category.id)/playlists?limit=50"), type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in
				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {
					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)
					let result = try JSONDecoder().decode(CategoryPLaylistsResponse.self, from: data)
					let playlists = result.playlists.items
					completion(.success(playlists))

				} catch {
					print("Error to load Category Playlists! \(error.localizedDescription)")
					completion(.failure(error))

				}
			}

			task.resume()
		}
	}

	//MARK: - Search requests
	public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {

		let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

		createRequest(with: URL(string: Constants.basicAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(queryString)"), type: .GET) { (request) in

			let task = URLSession.shared.dataTask(with: request) { data, _, error in

				guard let data = data, error == nil else {
					completion(.failure(APIError.failedToGetData))
					return
				}

				do {

					//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
					//                    print(json)

					let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
					var searchResults: [SearchResult] = []

					searchResults.append(contentsOf: result.albums.items.compactMap{ .album(model: $0)})
					searchResults.append(contentsOf: result.artists.items.compactMap{ .artist(model: $0)})
					searchResults.append(contentsOf: result.playlists.items.compactMap{ .playlist(model: $0)})
					searchResults.append(contentsOf: result.tracks.items.compactMap{ .track(model: $0)})

					completion(.success(searchResults))

				} catch {
					print("Error to load search! \(error.localizedDescription)")
					completion(.failure(error))
				}
			}

			task.resume()
		}

	}

	//MARK: - Private funcs
	private func createRequest(with url: URL?,
							   type: HTTPMethod,
							   completion: @escaping (URLRequest) -> Void) {

		AuthManager.shared.withValidToken { token in
			guard let apiURL = url else { return }
			// print("token =  \(token)")
			var request = URLRequest(url: apiURL)
			request.setValue("Bearer \(token)",
							 forHTTPHeaderField: "Authorization")
			request.httpMethod = type.rawValue
			request.timeoutInterval = 30
			completion(request)

		}
	}
}
