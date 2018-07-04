// Copyright (C) 2018 Don Kelly <karfai@gmail.com>

// This file is part of Interlibr, a functional component of an
// Internet of Rules (IoR).

// ACKNOWLEDGEMENTS
// Funds: Xalgorithms Foundation
// Collaborators: Don Kelly, Joseph Potvin and Bill Olders.

// This program is free software: you can redistribute it and/or
// modify it under the terms of the GNU Affero General Public License
// as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public
// License along with this program. If not, see
// <http://www.gnu.org/licenses/>.
package controllers

import javax.inject._
import play.api.mvc._
import play.api.libs.json._
import scala.util.{ Success, Failure }

import services.{ Mongo, MongoActions }

// FIXME: actor system context
import scala.concurrent.ExecutionContext.Implicits.global

@Singleton
class TracesController @Inject()(cc: ControllerComponents) extends AbstractController(cc) {
  private val _mongo = new Mongo()

  import services.Bson.Implicits.val_writes
  import services.Bson.Implicits.doc_writes

  def by_request(request_id: String) = Action.async {
    _mongo.find_many(MongoActions.FindManyTracesByRequestId(request_id)).map { docs =>
      Ok(Json.toJson(docs))
    }
  }

  def show(id: String) = Action.async {
    _mongo.find_one(MongoActions.FindTraceById(id)).map { doc =>
      Ok(Json.toJson(doc))
    }
  }
}
