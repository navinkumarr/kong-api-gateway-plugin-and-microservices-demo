package com.shaadi.search

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.ui.set
import org.springframework.web.bind.annotation.*

import com.github.kittinunf.fuel.*;
import com.github.kittinunf.fuel.jackson.*;

enum class Gender{ Male, Female}
enum class ProfileStatus{ Active, Deactivated}

data class Profile(val basic: Basic, val account: Account)
data class Basic (val age: Int, val gender: Gender , val first_name: String, val last_name: String)
data class Account (val status: ProfileStatus, val memberlogin: String)

typealias Profiles = List<Profile>

data class SearchResponse(val data: Profiles) 

@RestController
class SearchController {

    @GetMapping("/search")
    fun profiles(@RequestParam(value = "profileids") profileids: String) : SearchResponse {
        return fetchProfiles(profileids)
    }

    fun fetchFromCache(profileids: String): searchResponse{
        val (request, response, result) = Fuel.get("http://localhost:8081/cache/${profileids}")
            .responseObject<SearchResponse>()

        // not handling errors
        var (searchResponse, error) = result;

        if(searchResponse == null){
            searchResponse = SearchResponse(data = listOf())
        }

        return searchResponse
    }

    fun fetchProfiles(profileids: String): SearchResponse {
        val profiles = profileids.split(",")

        val (request, response, result) = Fuel.get("http://localhost:3000/profiles?profileids=${profileids}")
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
