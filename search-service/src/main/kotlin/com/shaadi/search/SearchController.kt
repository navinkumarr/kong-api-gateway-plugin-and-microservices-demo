package com.shaadi.search

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.ui.set
import org.springframework.web.bind.annotation.*

import com.github.kittinunf.fuel.*;
import com.github.kittinunf.fuel.jackson.*;
import com.fasterxml.jackson.module.kotlin.*

enum class Gender{ Male, Female}
enum class ProfileStatus{ Active, Deactivated}

data class Profile(val basic: Basic, val account: Account)
data class Basic (val age: Int, val gender: Gender , val first_name: String, val last_name: String)
data class Account (val status: ProfileStatus, val memberlogin: String)

data class Cache (val key: String, val value: String, val id: Int?, val expiry: Long)

typealias Profiles = List<Profile>

data class SearchResponse(val data: Profiles) 

@RestController
class SearchController {

    @GetMapping("/search")
    fun profiles(@RequestParam(value = "profileids") profileids: String) : SearchResponse {

        var searchResponse = fetchFromCache(profileids)

        if(searchResponse == null){
            searchResponse = fetchProfiles(profileids)
            if(searchResponse.data.size > 0) {
                saveInCache(profileids, searchResponse)
            }
        }

        return searchResponse
    }

    fun saveInCache(profileids: String, searchResponse: SearchResponse) {
        val mapper = jacksonObjectMapper()
        val unixTime = System.currentTimeMillis() / 1000;

        val cacheData = Cache(id = null, key = profileids, value = mapper.writeValueAsString(searchResponse.data), expiry = unixTime + 60)

        val (request, response, error) = Fuel.post("http://cache-service:8080/cache/")
            .header("Content-Type","application/json")
            .body(mapper.writeValueAsString(cacheData))
            .response()

    }

    fun fetchFromCache(profileids: String): SearchResponse? {
        val (request, response, result) = Fuel.get("http://cache-service:8080/cache/${profileids}")
            .responseObject<ArrayList<Cache>>()

        // not handling errors
        var (cacheResponse, error) = result;

        if(cacheResponse == null  || cacheResponse.size == 0){
            return null
        }

        val mapper = jacksonObjectMapper()

        val profiles = mapper.readValue<Profiles>(cacheResponse.get(0).value)

        val searchResponse = SearchResponse(data = profiles)

        return searchResponse
    }

    fun fetchProfiles(profileids: String): SearchResponse {
        val profiles = profileids.split(",")

        val (request, response, result) = Fuel.get("http://profile-service:3000/profiles?profileids=${profileids}")
            .responseObject<SearchResponse>()

        // not handling errors
        var (searchResponse, error) = result;

        if(searchResponse == null){
            searchResponse = SearchResponse(data = listOf())
        }

        return searchResponse
    }

    fun sampleProfile(): SearchResponse {
        val profile = Profile (
            basic = Basic (
                    age = 28,
                    gender = Gender.Male,
                    first_name = "Navin",
                    last_name = "Singh"
            ),
            account = Account (
                    status = ProfileStatus.Active,
                    memberlogin = "a1q1q1"
            )
        );

        return SearchResponse( data = listOf(profile))
    }
}
