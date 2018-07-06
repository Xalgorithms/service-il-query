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

import collection.JavaConverters._
import javax.inject._
import org.bson._
import play.api.mvc._
import play.api.libs.json._
import scala.util.{ Success, Failure }

import org.xalgorithms.storage.bson.BsonJson
import org.xalgorithms.storage.bson.Find

import services.{ Mongo, MongoActions }

// FIXME: actor system context
import scala.concurrent.ExecutionContext.Implicits.global

@Singleton
class StepsController @Inject()(cc: ControllerComponents) extends AbstractController(cc) {
  private val _mongo = new Mongo()

  import BsonJson.Implicits.val_writes

  def index(trace_id: String) = Action.async {
    _mongo.find_one(MongoActions.FindTraceById(trace_id)).map { doc =>
      Find.maybe_find_array_as_seq(doc.toBsonDocument, "steps") match {
        case Some(steps) => {
          Ok(Json.toJson(steps))
        }

        case None => NotFound(Json.obj("status" -> "failure_no_steps_in_trace"))
      }
    }
  }

  def show(trace_id: String, number: Int) = Action.async {
    _mongo.find_one(MongoActions.FindTraceById(trace_id)).map { doc =>
      Find.maybe_find_array_as_seq(doc.toBsonDocument, "steps") match {
        case Some(steps) => {
          if (number < steps.size) {
            Ok(Json.toJson(steps(number)))
          } else {
            NotFound(Json.obj("status" -> "failure_no_such_step"))
          }
        }

        case None => NotFound(Json.obj("status" -> "failure_no_steps_in_trace"))
      }
    }
  }
}
